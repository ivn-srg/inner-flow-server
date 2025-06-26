import Vapor

struct ChatSendRequest: Content {
    var userId: UUID
    var message: String
}

struct ChatSendResponse: Content {
    var reply: String
    var emotion: String
    var timestamp: Date
} 