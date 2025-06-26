import Vapor

struct RegisterRequest: Content {
    var email: String?
    var password: String?
    var anonymous: Bool?
    var settings: UserSettingsDTO?
}

struct LoginRequest: Content {
    var email: String
    var password: String
}

struct AuthTokenResponse: Content {
    var token: String
} 