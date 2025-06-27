import Vapor

enum ChatEmotion: String, Codable, Content {
    case anxiety, calm, anger, joy, sadness
}

struct ChatMessageDTO: Content {
    var id: UUID?
    var userId: UUID
    var message: String
    var reply: String
    var emotion: ChatEmotion
    var timestamp: Date
} 