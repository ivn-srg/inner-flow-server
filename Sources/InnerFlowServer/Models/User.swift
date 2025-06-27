import Fluent
import Vapor

final class User: Model, Content, Authenticatable, @unchecked Sendable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "email")
    var email: String

    @Field(key: "name")
    var name: String

    @Field(key: "gender")
    var gender: Gender

    @Field(key: "age")
    var age: Int

    @Field(key: "created_at")
    var createdAt: Date

    @Field(key: "settings")
    var settings: UserSettings

    init() { }

    init(id: UUID? = nil, email: String, name: String, gender: Gender, age: Int, createdAt: Date = Date(), settings: UserSettings) {
        self.id = id
        self.email = email
        self.name = name
        self.gender = gender
        self.age = age
        self.createdAt = createdAt
        self.settings = settings
    }
}

struct UserSettings: Codable, Content {
    var tone: Tone
    var language: Language
} 