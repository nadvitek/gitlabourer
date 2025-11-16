import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app.get("health") { req in
        "OK"
    }

    // GitLab webhook
//    app.post("gitlab", "webhook") { req -> HTTPStatus in
//        let payload = try req.content.decode(GitLabPipelineEvent.self)
//        try await handleGitLabPipelineEvent(payload, app: req.application)
//        return .ok
//    }
//
//    // KMP: subscribe to MR
//    app.post("subscriptions") { req -> HTTPStatus in
//        let body = try req.content.decode(SubscriptionRequest.self)
//        try await saveSubscription(body, app: req.application)
//        return .ok
//    }
//
//    // KMP: get current status
//    app.get("pipelines", ":mrId") { req -> PipelineStatusResponse in
//        let mrId = req.parameters.get("mrId")!
//        return try await getCurrentStatus(for: mrId, app: req.application)
//    }

    app.post("subscribe") { req async throws -> HTTPStatus in
        let body = try req.content.decode(SubscribeRequest.self)

        let sub = Subscription(
            userId: body.userId,
            baseUrl: body.baseUrl,
            token: body.token,
        )

        try await req.firestore.saveSubscription(sub)
        return .ok
    }

    app.get("merge-requests") { req async throws -> [Result] in
        let cfg = req.application.gitlabConfig
        let gitlab = GitLabClient(
            client: req.client,
            baseURL: cfg.baseURL,
            token: cfg.token
        )

        return try await gitlab.mergeRequests()
    }

//    app.get("poll-merge-requests") { req async throws -> String in
//        let cache = req.application.storage[PipelineCacheKey.self]!
//
//        let gitlab = GitLabClient(
//            client: req.client,
//            baseURL: URI(string: Environment.get("GITLAB_BASE_URL") ?? "https://gitlab.ack.ee/api/v4"),
//            token: Environment.get("GITLAB_TOKEN")!
//        )
//
//        let results = try await gitlab.mergeRequests()
//
//        for result in results {
//            let pipelineId = result.pipeline.id
//            let newStatus  = result.pipeline.status
//
//            let lastStatus = await cache.lastStatus(for: pipelineId)
//
//            if lastStatus == nil {
//                // first time seeing this pipeline
//                print("🆕 Initial status for pipeline \(pipelineId): \(newStatus)")
//                await cache.updateStatus(pipelineId: pipelineId, status: newStatus)
//            } else if lastStatus != newStatus {
//                // status changed
//                print("🔔 Pipeline \(pipelineId) changed: \(lastStatus!) → \(newStatus)")
//                await cache.updateStatus(pipelineId: pipelineId, status: newStatus)
//
//                // TODO later: send push or notify KMP
//            }
//        }
//
//        // TODO: - Remove all old Pipelines
//
//        return "OK"
//    }

    app.get("poll-merge-requests") { req async throws -> String in
        let firestore = req.firestore
        let cache = req.application.pipelineCache

        // 1) Load all subscriptions (per user baseUrl + token + projectId)
        let subs = try await firestore.loadAllSubscriptions()

        for sub in subs {
            req.logger.info("Polling GitLab for user \(sub.userId) at \(sub.baseUrl)")

            let gitlab = GitLabClient(
                client: req.client,
                baseURL: URI(string: sub.baseUrl),
                token: sub.token
            )

            // 2) Get current MR+pipeline results for this user
            let results: [Result] = try await gitlab.mergeRequests()

            for result in results {
                let mr = result.mergeRequest
                let pipeline = result.pipeline

                // Unique key for this pipeline for this user
                // You can tweak this shape however you like
                let key = "\(sub.userId):\(mr.project_id):\(mr.iid):\(pipeline.id)"

                let newStatus = pipeline.status
                let lastStatus = await cache.lastStatus(for: key)

                if let last = lastStatus {
                    if last != newStatus {
                        // 3a) Status changed
                        req.logger.info(
                            "🔔 Pipeline changed [user=\(sub.userId), project=\(mr.project_id), MR=\(mr.iid), pipeline=\(pipeline.id)]: \(last) → \(newStatus)"
                        )

                        // TODO: here you can:
                        // - write newStatus to Firestore for the client to read
                        // - send FCM / APNs notification
                    }
                } else {
                    // 3b) First time we see this pipeline
                    req.logger.info(
                        "🆕 First status for pipeline [user=\(sub.userId), project=\(mr.project_id), MR=\(mr.iid), pipeline=\(pipeline.id)]: \(newStatus)"
                        // You might also notify here if you want "pipeline started" messages
                    )
                }

                // 4) Update cache with latest status
                await cache.updateStatus(newStatus, for: key)
            }
        }

        return "OK"
    }
}
