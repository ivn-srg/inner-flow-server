import Fluent
import Vapor

final class User: Model, Content, Authenticatable, @unchecked Sendable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "email")
    var email: String

    @Field(key: "created_at")
    var createdAt: Date

    @Field(key: "settings")
    var settings: UserSettings

    init() { }

    init(id: UUID? = nil, email: String, createdAt: Date = Date(), settings: UserSettings) {
        self.id = id
        self.email = email
        self.createdAt = createdAt
        self.settings = settings
    }
}

struct UserSettings: Codable, Content {
    var tone: String // empathetic | rational | humorous
    var language: String // ru
} 