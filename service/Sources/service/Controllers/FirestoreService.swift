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

    // token cache isolated in an actor to be Sendable-safe
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
        let fields = SubscriptionFields(
            userId: .init(stringValue: sub.userId),
            baseUrl: .init(stringValue: sub.baseUrl),
            token: .init(stringValue: sub.token)
        )

        let doc = FirestoreDocument<SubscriptionFields>(
            name: nil,
            fields: fields,
            createTime: nil,
            updateTime: nil
        )

        let url = documentURL(collection: "subscriptions", documentId: sub.userId)
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
        let list = try res.content.decode(ListDocumentsResponse<SubscriptionFields>.self)

        let docs = list.documents ?? []

        return docs.map { doc in
            let f = doc.fields
            return Subscription(
                userId: f.userId.stringValue,
                baseUrl: f.baseUrl.stringValue,
                token: f.token.stringValue
            )
        }
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

        // Use the JWTSigners stored on Application via actor box
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

// MARK: - Storage key

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
