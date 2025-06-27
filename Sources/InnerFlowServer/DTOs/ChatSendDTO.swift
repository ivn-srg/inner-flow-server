import Vapor

struct ChatSendRequest: Content {
    var message: String
}

struct ChatSendResponse: Content {
    var reply: String
    var emotion: ChatEmotion
    var timestamp: Date
} 