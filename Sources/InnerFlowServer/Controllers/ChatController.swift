import Vapor
import Fluent

struct ChatController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let chat = routes.grouped(JWTMiddleware()).grouped("api", "v1", "chat")
        chat.post("send", use: send)
        chat.get("history", use: history)
    }

    func send(req: Request) async throws -> ChatSendResponse {
        let user = try req.auth.require(User.self)
        let data = try req.content.decode(ChatSendRequest.self)
        let emotionStr = EmotionAnalyzerMock().analyze(text: data.message)
        let emotion = ChatEmotion(rawValue: emotionStr) ?? .calm
        let reply = try await LLMChatMock().generateReply(userMessage: data.message, emotion: emotion.rawValue)
        let message = ChatMessage(
            userID: try user.requireID(),
            message: data.message,
            reply: reply,
            emotion: emotion,
            timestamp: Date()
        )
        try await message.save(on: req.db)
        return ChatSendResponse(reply: reply, emotion: emotion, timestamp: message.timestamp)
    }

    func history(req: Request) async throws -> [ChatMessageDTO] {
        let user = try req.auth.require(User.self)
        let messages = try await ChatMessage.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .sort(\.$timestamp, .descending)
            .limit(50)
            .all()
        return messages.map { msg in
            ChatMessageDTO(
                id: msg.id,
                userId: msg.$user.id,
                message: msg.message,
                reply: msg.reply,
                emotion: msg.emotion,
                timestamp: msg.timestamp
            )
        }
    }
} 
