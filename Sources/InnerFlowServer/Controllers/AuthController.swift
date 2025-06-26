import Vapor
import Fluent
import Crypto

struct AuthController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let auth = routes.grouped("api", "v1", "auth")
        auth.post("register", use: register)
        auth.post("login", use: login)
        auth.get("me", use: me)
    }

    func register(req: Request) async throws -> AuthTokenResponse {
        let data = try req.content.decode(RegisterRequest.self)
        let email = data.email?.lowercased()
        let password = data.password
        let anonymous = data.anonymous ?? false
        let settings = data.settings ?? UserSettingsDTO(tone: "empathetic", language: "ru")

        if !anonymous {
            guard let email = email, let password = password, !email.isEmpty, !password.isEmpty else {
                throw Abort(.badRequest, reason: "Email and password required")
            }
            guard try await User.query(on: req.db).filter(\.$email == email).first() == nil else {
                throw Abort(.conflict, reason: "User already exists")
            }
            let user = User(email: email, createdAt: Date(), settings: UserSettings(tone: settings.tone, language: settings.language))
            try await user.save(on: req.db)
            let hash = try Bcrypt.hash(password)
            let userPassword = UserPassword(userID: try user.requireID(), passwordHash: hash)
            try await userPassword.save(on: req.db)
            let token = try JWTService().generateToken(user: user)
            return AuthTokenResponse(token: token)
        } else {
            // Анонимная регистрация
            let user = User(email: "anonymous_\(UUID().uuidString)", createdAt: Date(), settings: UserSettings(tone: settings.tone, language: settings.language))
            try await user.save(on: req.db)
            let token = try JWTService().generateToken(user: user)
            return AuthTokenResponse(token: token)
        }
    }

    func login(req: Request) async throws -> AuthTokenResponse {
        let data = try req.content.decode(LoginRequest.self)
        let email = data.email.lowercased()
        guard let user = try await User.query(on: req.db).filter(\.$email == email).first() else {
            throw Abort(.unauthorized, reason: "User not found")
        }
        guard let userPassword = try await UserPassword.query(on: req.db).filter(\.$user.$id == user.requireID()).first() else {
            throw Abort(.unauthorized, reason: "Password not set")
        }
        guard try Bcrypt.verify(data.password, created: userPassword.passwordHash) else {
            throw Abort(.unauthorized, reason: "Invalid password")
        }
        let token = try JWTService().generateToken(user: user)
        return AuthTokenResponse(token: token)
    }

    func me(req: Request) async throws -> UserDTO {
        let user = try req.auth.require(User.self)
        return UserDTO(
            id: try user.requireID(),
            email: user.email,
            createdAt: user.createdAt,
            settings: UserSettingsDTO(tone: user.settings.tone, language: user.settings.language)
        )
    }
} 
