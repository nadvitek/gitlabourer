import Vapor
import Crypto

actor EncryptionService {
    private let key: SymmetricKey

    init(keyData: Data) {
        self.key = SymmetricKey(data: keyData)
    }

    func encrypt(_ plaintext: String) throws -> String {
        let data = Data(plaintext.utf8)
        let sealed = try AES.GCM.seal(data, using: key)
        let combined = sealed.combined!
        return combined.base64EncodedString()
    }

    func decrypt(_ base64Ciphertext: String) throws -> String {
        guard let combined = Data(base64Encoded: base64Ciphertext) else {
            throw Abort(.internalServerError, reason: "Invalid base64 for encrypted token")
        }

        let sealedBox = try AES.GCM.SealedBox(combined: combined)
        let decrypted = try AES.GCM.open(sealedBox, using: key)
        return String(decoding: decrypted, as: UTF8.self)
    }
}

struct EncryptionServiceKey: StorageKey {
    typealias Value = EncryptionService
}

extension Application {
    var encryption: EncryptionService {
        get {
            guard let service = storage[EncryptionServiceKey.self] else {
                fatalError("EncryptionService not configured")
            }
            return service
        }
        set {
            storage[EncryptionServiceKey.self] = newValue
        }
    }
}

extension Request {
    var encryption: EncryptionService {
        application.encryption
    }
}
