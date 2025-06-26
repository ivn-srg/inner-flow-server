import Vapor

struct UserDTO: Content {
    var id: UUID?
    var email: String
    var createdAt: Date
    var settings: UserSettingsDTO
}

struct UserSettingsDTO: Content {
    var tone: String
    var language: String
} 