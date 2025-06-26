import Vapor
import JWTKit

struct UserPayload: JWTPayload {
    var userId: UUID
    var email: String
    var exp: ExpirationClaim

    func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}

final class JWTService {
    // В продакшене вынести в переменные окружения!
    private let signer = JWTSigner.hs256(key: "super-secret-key-change-me")
    private let expiration: TimeInterval = 60 * 60 * 24 * 7 // 7 дней

    func generateToken(user: User) throws -> String {
        let payload = UserPayload(
            userId: try user.requireID(),
            email: user.email,
            exp: .init(value: Date().addingTimeInterval(expiration))
        )
        return try signer.sign(payload)
    }

    func verifyToken(_ token: String) throws -> UserPayload {
        return try signer.verify(token, as: UserPayload.self)
    }
} 