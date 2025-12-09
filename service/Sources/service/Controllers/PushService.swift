import Vapor
@preconcurrency import APNSwift
import Foundation
import NIOCore
import JWTKit

// MARK: - Payload model

struct PipelinePushPayload: Codable {
    struct MRPayload: Codable {
        let projectId: Int
        let iid: Int
        let title: String
    }

    struct PipelinePayload: Codable {
        let id: Int
        let status: String
    }

    let mr: MRPayload
    let pipeline: PipelinePayload
}

struct APNSConfig {
    let keyId: String
    let teamId: String
    let bundleId: String
    let environment: APNSwiftConfiguration.Environment
    let privateKey: String
}

// MARK: - Service

actor PushService {
    private let app: Application
    private let config: APNSwiftConfiguration

    init(app: Application, config: APNSConfig) throws {
        self.app = app

        let pem = config.privateKey.replacingOccurrences(of: "\\n", with: "\n")

        self.config = try APNSwiftConfiguration(
            authenticationMethod: .jwt(
                key: .private(pem: pem),
                keyIdentifier: JWKIdentifier(string: config.keyId),
                teamIdentifier: config.teamId
            ),
            topic: config.bundleId,
            environment: config.environment
        )
    }

    func sendPipelineUpdate(to deviceToken: String, result: Result, userId: String) async {
        let mr = result.mergeRequest
        let pipeline = result.pipeline

        let aps: [String: Any] = [
            "alert": [
                "title": result.projectName,
                "body": "Pipeline is \(pipeline.status.rawValue) for Merge Request \(mr.title)"
            ],
            "sound": "default",
            "mutable-content": 1
        ]

        let payload: [String: Any] = [
            "aps": aps,
            "mr": [
                "projectId": mr.project_id,
                "iid": mr.iid,
                "title": mr.title
            ],
            "pipeline": [
                "id": pipeline.id,
                "status": pipeline.status.rawValue
            ]
        ]

        let jsonBytes: [UInt8]
        do {
            let data = try JSONSerialization.data(withJSONObject: payload)
            jsonBytes = Array(data)
        } catch {
            app.logger.error("Failed to encode APNs JSON: \(error)")
            return
        }

        APNSwiftConnection
            .connect(configuration: config, on: app.eventLoopGroup.next())
            .flatMap { connection in
                connection.send(
                    raw: jsonBytes,
                    pushType: .alert,
                    to: deviceToken,
                    expiration: nil,
                    priority: nil,
                    collapseIdentifier: nil,
                    topic: nil,
                    loggerConfig: .clientLogger,
                    apnsID: nil
                ).flatMap { response in
                    self.app.logger.info("APNs push sent to user=\(userId), response: \(response)")
                    return connection.close()
                }
            }
            .whenComplete { result in
                if case let .failure(error) = result {
                    self.app.logger.report(error: error)
                }
            }
    }
}

// MARK: - Application storage

struct PushServiceKey: StorageKey {
    typealias Value = PushService
}

extension Application {
    var push: PushService {
        get {
            guard let svc = storage[PushServiceKey.self] else {
                fatalError("PushService not configured. Call app.push = ... in configure()")
            }
            return svc
        }
        set {
            storage[PushServiceKey.self] = newValue
        }
    }
}
