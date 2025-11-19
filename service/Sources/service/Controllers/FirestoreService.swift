import Foundation
import Vapor
import JWTKit

// Actor to safely cache the auth token across concurrency domains
actor AuthTokenCache {
    private var token: AuthToken?

    func get() -> AuthToken? {
        token
    }

    func set(_ newValue: AuthToken?) {
        token = newValue
    }
}

// Actor wrapper to hold JWTSigners safely across concurrency domains
actor JWTSignersBox {
    private var signers: JWTSigners?

    func set(_ value: JWTSigners) {
        signers = value
    }

    func sign(_ payload: some JWTPayload) throws -> String {
        guard let signers else {
            throw Abort(.internalServerError, reason: "JWTSigners not configured. Initialize in configure().")
        }
        return try signers.sign(payload)
    }
}

final class FirestoreService: @unchecked Sendable {
    let app: Application
    let apiUrl = "https://firestore.googleapis.com/v1"
    let projectId: String
    let clientEmail: String
    let scope: String

    private let tokenCache = AuthTokenCache()

    init(app: Application, projectId: String, clientEmail: String, scope: String) {
        self.app = app
        self.projectId = projectId
        self.clientEmail = clientEmail
        self.scope = scope
    }

    // MARK: - Public API

    /// Save or overwrite a subscription for a userId
    func saveSubscription(_ sub: Subscription) async throws {
        let encryptedToken = try await app.encryption.encrypt(sub.token)

        let fields = SubscriptionFields(
            userId: .init(stringValue: sub.userId),
            baseUrl: .init(stringValue: sub.baseUrl),
            token: .init(stringValue: encryptedToken)
        )

        let doc = FirestoreDocument<SubscriptionFields>(
            name: nil,
            fields: fields,
            createTime: nil,
            updateTime: nil
        )

        let documentId = "\(sub.baseUrl)_\(sub.userId)"

        let url = documentURL(collection: "subscriptions", documentId: documentId)
        let headers = try await authHeaders()

        _ = try await app.client.patch(URI(string: url), headers: headers) { req in
            try req.content.encode(doc)
        }

        app.logger.info("Saved subscription for userId \(sub.userId)")
    }

    /// Load all subscriptions (for polling job)
    func loadAllSubscriptions() async throws -> [Subscription] {
        let url = listDocumentsURL(collection: "subscriptions")
        let headers = try await authHeaders()

        let res = try await app.client.get(URI(string: url), headers: headers)

        if res.status != .ok {
            let bodyString = res.body.flatMap { String(buffer: $0) } ?? "<no body>"
            app.logger.error("Firestore listDocuments error: \(res.status) \(bodyString)")
            throw Abort(.internalServerError, reason: "Firestore error: \(res.status)")
        }

        let list = try res.content.decode(ListDocumentsResponse<SubscriptionFields>.self)
        let docs = list.documents ?? []

        var subscriptions: [Subscription] = []
        subscriptions.reserveCapacity(docs.count)

        for doc in docs {
            let f = doc.fields
            let decryptedToken = try await app.encryption.decrypt(f.token.stringValue)
            let sub = Subscription(
                userId: f.userId.stringValue,
                baseUrl: f.baseUrl.stringValue,
                token: decryptedToken
            )
            subscriptions.append(sub)
        }

        return subscriptions
    }

    func savePipelineStatus(for sub: Subscription, result: Result) async throws {
        let mr = result.mergeRequest
        let pipeline = result.pipeline

        let now = ISO8601DateFormatter().string(from: Date())

        let fields = NotificationFields(
            userId: .init(stringValue: sub.userId),
            projectId: .init(integerValue: String(mr.project_id)),
            mrIid: .init(integerValue: String(mr.iid)),
            mrTitle: .init(stringValue: mr.title),
            pipelineId: .init(integerValue: String(pipeline.id)),
            pipelineStatus: .init(stringValue: pipeline.status.rawValue),
            updatedAt: .init(stringValue: now)
        )

        let doc = FirestoreDocument(
            name: nil,
            fields: fields,
            createTime: nil,
            updateTime: nil
        )

        let docId = "\(sub.baseUrl)_\(sub.userId)_\(mr.project_id)_\(mr.iid)_\(pipeline.id)"
        let url = documentURL(collection: "pipelineStatuses", documentId: docId)
        let headers = try await authHeaders()

        _ = try await app.client.patch(URI(string: url), headers: headers) { req in
            try req.content.encode(doc)
        }

        app.logger.info("Saved pipeline status for user=\(sub.userId), project=\(mr.project_id), MR=\(mr.iid)")
    }

    // MARK: - Private helpers

    private func authHeaders() async throws -> HTTPHeaders {
        let token = try await getAccessToken()
        var headers = HTTPHeaders()
        headers.bearerAuthorization = .init(token: token.token)
        headers.add(name: .contentType, value: "application/json")
        return headers
    }

    private func documentURL(collection: String, documentId: String) -> String {
        "\(apiUrl)/projects/\(projectId)/databases/(default)/documents/\(collection)/\(documentId)"
    }

    private func listDocumentsURL(collection: String) -> String {
        "\(apiUrl)/projects/\(projectId)/databases/(default)/documents/\(collection)"
    }

    // MARK: - Auth

    private func getAccessToken() async throws -> AuthToken {
        if let token = await tokenCache.get(), !token.expired {
            return token
        }

        let newToken = try await authenticate()
        let authToken = AuthToken(
            token: newToken.token,
            expiresAt: Date().addingTimeInterval(TimeInterval(newToken.expiresIn))
        )
        await tokenCache.set(authToken)
        return authToken
    }

    private func authenticate() async throws -> GoogleAccessToken {
        let now = Date()
        let oneHour: TimeInterval = 60 * 60

        let payload = FirebaseJWTPayload(
            iss: IssuerClaim(value: clientEmail),
            scope: scope,
            aud: AudienceClaim(value: "https://oauth2.googleapis.com/token"),
            exp: ExpirationClaim(value: now.addingTimeInterval(oneHour)),
            iat: IssuedAtClaim(value: now)
        )

        let assertion = try await app.jwtSignersBox.sign(payload)

        let body = FirebaseAuthRequest(
            grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
            assertion: assertion
        )

        let res = try await app.client.post(URI(string: "https://oauth2.googleapis.com/token")) { req in
            try req.content.encode(body, as: .urlEncodedForm)
        }

        return try res.content.decode(GoogleAccessToken.self)
    }
}

// MARK: - AuthTokenKey

struct AuthTokenKey: StorageKey {
    typealias Value = AuthToken
}

// MARK: - Application + Request extensions

extension Application {
    var firestore: FirestoreService {
        get {
            guard let fs = storage[FirestoreServiceKey.self] else {
                fatalError("FirestoreService not configured. Call app.firestore = ... in configure()")
            }
            return fs
        }
        set {
            storage[FirestoreServiceKey.self] = newValue
        }
    }
}

struct FirestoreServiceKey: StorageKey {
    typealias Value = FirestoreService
}

extension Request {
    var firestore: FirestoreService {
        application.firestore
    }
}

// MARK: - JWTSigners storage

private struct JWTSignersBoxKey: StorageKey {
    typealias Value = JWTSignersBox
}

extension Application {
    var jwtSignersBox: JWTSignersBox {
        get {
            if let s = storage[JWTSignersBoxKey.self] {
                return s
            }
            let box = JWTSignersBox()
            storage[JWTSignersBoxKey.self] = box
            return box
        }
        set {
            storage[JWTSignersBoxKey.self] = newValue
        }
    }
}
