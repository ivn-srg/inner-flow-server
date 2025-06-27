import Vapor

enum Gender: String, Codable, Content {
    case male, female, other, unspecified
}

enum Tone: String, Codable, Content {
    case empathetic, rational, humorous
}

enum Language: String, Codable, Content {
    case ru, en
}

struct UserDTO: Content {
    var id: UUID?
    var email: String
    var name: String
    var gender: Gender
    var age: Int
    var createdAt: Date
    var settings: UserSettingsDTO
}

struct UserSettingsDTO: Content {
    var tone: Tone
    var language: Language
} 