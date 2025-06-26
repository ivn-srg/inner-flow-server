import Vapor

struct JWTMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        let jwtService = JWTService()
        guard let bearer = request.headers.bearerAuthorization else {
            throw Abort(.unauthorized, reason: "Missing Bearer token")
        }
        let payload: UserPayload
        do {
            payload = try jwtService.verifyToken(bearer.token)
        } catch {
            throw Abort(.unauthorized, reason: "Invalid or expired token")
        }
        guard let user = try await User.find(payload.userId, on: request.db) else {
            throw Abort(.unauthorized, reason: "User not found")
        }
        request.auth.login(user)
        return try await next.respond(to: request)
    }
} 
