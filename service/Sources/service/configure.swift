import Vapor
import JWTKit

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    guard
        let rawPrivateKey = Environment.get("FIREBASE_PRIVATE_KEY"),
        let clientEmail   = Environment.get("FIREBASE_CLIENT_EMAIL"),
        let projectId     = Environment.get("FIREBASE_PROJECT_ID"),
        let scope         = Environment.get("FIREBASE_TOKEN_SCOPE")
    else {
        fatalError("Missing FIREBASE_* env vars")
    }

    guard
        let encryptionKeyBase64 = Environment.get("ENCRYPTION_KEY"),
        let keyData = Data(base64Encoded: encryptionKeyBase64)
    else {
        fatalError("ENCRYPTION_KEY env var must be set to 32 random bytes in base64")
    }

    guard
        let apnsKeyId = Environment.get("APNS_KEY_ID"),
        let apnsTeamId = Environment.get("APNS_TEAM_ID"),
        let apnsBundleId = Environment.get("APNS_BUNDLE_ID"),
        let apnsPrivateKey = Environment.get("APNS_PRIVATE_KEY")
    else {
        app.logger.warning("APNS_* env vars not fully set, PushService disabled")
        // you can early-return or just skip configuring push
        return try routes(app)
    }

    let apnsConfig = APNSConfig(
        keyId: apnsKeyId,
        teamId: apnsTeamId,
        bundleId: apnsBundleId,
        environment: .sandbox, // TODO: - Change to production
        privateKey: apnsPrivateKey
    )

    app.push = try PushService(app: app, config: apnsConfig)

    // Replace literal "\n" with real newlines (common when storing key in env)
    let privateKeyPEM = rawPrivateKey.replacingOccurrences(of: "\\n", with: "\n")

    app.encryption = EncryptionService(keyData: keyData)

    let signers = JWTSigners()
    let rsaPrivateKey = try RSAKey.private(pem: privateKeyPEM)
    signers.use(.rs256(key: rsaPrivateKey))
    await app.jwtSignersBox.set(signers)

    app.firestore = FirestoreService(
        app: app,
        projectId: projectId,
        clientEmail: clientEmail,
        scope: scope
    )

    app.pipelineCache = PipelineCache()

    try routes(app)
}
