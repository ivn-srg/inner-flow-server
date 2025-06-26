import Fluent
import Vapor

final class UserPassword: Model, Content, @unchecked Sendable {
    static let schema = "user_passwords"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "password_hash")
    var passwordHash: String

    init() { }

    init(id: UUID? = nil, userID: UUID, passwordHash: String) {
        self.id = id
        self.$user.id = userID
        self.passwordHash = passwordHash
    }
} 