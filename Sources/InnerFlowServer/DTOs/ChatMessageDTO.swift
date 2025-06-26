import Vapor

struct ChatMessageDTO: Content {
    var id: UUID?
    var userId: UUID
    var message: String
    var reply: String
    var emotion: String
    var timestamp: Date
} 