import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works, buddy!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: AuthController())
    try app.register(collection: ChatController())
    try app.register(collection: DiaryController())
    try app.register(collection: VoiceController())
    try app.register(collection: UtilsController())

    // Защищённый эндпоинт /api/v1/auth/me
    let protected = app.grouped(JWTMiddleware())
    protected.get("api", "v1", "auth", "me", use: AuthController().me)
}
