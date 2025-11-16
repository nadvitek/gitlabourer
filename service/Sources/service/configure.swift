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

    // Replace literal "\n" with real newlines (common when storing key in env)
    let privateKeyPEM = rawPrivateKey.replacingOccurrences(of: "\\n", with: "\n")

    // Build JWTSigners explicitly and store via actor-backed box
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

    // register routes
    try routes(app)
}
