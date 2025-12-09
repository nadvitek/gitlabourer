import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works and it is new version!"
    }

    app.get("health") { req in
        "OK"
    }

    app.post("subscribe") { req async throws -> HTTPStatus in
        let body = try req.content.decode(SubscribeRequest.self)

        let sub = Subscription(
            userId: body.userId,
            baseUrl: body.baseUrl,
            token: body.token,
            apnsDeviceToken: body.apnsDeviceToken
        )

        try await req.firestore.saveSubscription(sub)
        return .ok
    }

    app.get("poll-merge-requests") { req async throws -> String in
        let firestore = req.firestore
        req.logger.info("Firestore gathered")
        let cache = req.application.pipelineCache
        let push = req.application.push

        req.logger.info("Cache gathered")

        let subs = try await firestore.loadAllSubscriptions()

        req.logger.info("Subscriptions gathered")

        for sub in subs {
            req.logger.info("Polling GitLab for user \(sub.userId) at \(sub.baseUrl)")

            let gitlab = GitLabClient(
                client: req.client,
                baseURL: URI(string: sub.baseUrl),
                token: sub.token
            )

            let results: [Result] = try await gitlab.mergeRequests()

            await processResults(
                results: results,
                sub: sub,
                logger: req.logger,
                cache: cache,
                firestore: req.firestore,
                push: push
            )
        }

        return "OK"
    }
}

private func processResults(
    results: [Result],
    sub: Subscription,
    logger: Logger,
    cache: PipelineCache,
    firestore: FirestoreService,
    push: PushService
) async {
    for result in results {
        let mr = result.mergeRequest
        let pipeline = result.pipeline

        let key = "\(sub.userId):\(mr.project_id):\(mr.iid):\(pipeline.id)"

        let newStatus = pipeline.status
        let lastStatus = await cache.lastStatus(for: key)

        guard let deviceToken = sub.apnsDeviceToken else {
            continue
        }

        if let lastStatus {
            if lastStatus != newStatus {
                logger.info(
                    "🔔 Pipeline changed [user=\(sub.userId), project=\(mr.project_id), MR=\(mr.iid), pipeline=\(pipeline.id)]: \(lastStatus) → \(newStatus)"
                )

                await cache.updateStatus(newStatus, for: key)
                await push.sendPipelineUpdate(to: deviceToken, result: result, userId: sub.userId)
            } else if newStatus.isFinished {
                logger.info(
                    "🔔 First status for pipeline [user=\(sub.userId), project=\(mr.project_id), MR=\(mr.iid), pipeline=\(pipeline.id)]: Status is \(newStatus)"
                )

                await cache.removeValue(for: key)
                await push.sendPipelineUpdate(to: deviceToken, result: result, userId: sub.userId)
            }
        } else if newStatus.isRunning {
            logger.info(
                "🆕 First status for pipeline [user=\(sub.userId), project=\(mr.project_id), MR=\(mr.iid), pipeline=\(pipeline.id)]: Status is \(newStatus)"
            )

            await cache.updateStatus(newStatus, for: key)
            await push.sendPipelineUpdate(to: deviceToken, result: result, userId: sub.userId)
        }
    }
}
