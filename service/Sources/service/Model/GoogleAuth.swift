import Vapor
import JWTKit
import Foundation

// MARK: - Auth token cache

struct AuthToken {
    let token: String
    let expiresAt: Date

    var expired: Bool {
        // refresh 60s before actual expiry
        Date() >= expiresAt.addingTimeInterval(-60)
    }
}

// MARK: - Google OAuth response

struct GoogleAccessToken: Content {
    let access_token: String
    let expires_in: Int
    let token_type: String

    var token: String { access_token }
    var expiresIn: Int { expires_in }
}

// MARK: - Firebase JWT payload for service account

struct FirebaseJWTPayload: JWTPayload {
    let iss: IssuerClaim
    let scope: String
    let aud: AudienceClaim
    let exp: ExpirationClaim
    let iat: IssuedAtClaim

func verify(using signer: JWTKit.JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}

// MARK: - OAuth request body

struct FirebaseAuthRequest: Content {
    let grant_type: String
    let assertion: String
}
