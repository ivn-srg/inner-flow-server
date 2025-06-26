import Fluent
import Vapor

final class ChatMessage: Model, Content, @unchecked Sendable {
    static let schema = "chat_messages"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "message")
    var message: String

    @Field(key: "reply")
    var reply: String

    @Field(key: "emotion")
    var emotion: String // anxiety | calm | anger

    @Field(key: "timestamp")
    var timestamp: Date

    init() { }

    init(id: UUID? = nil, userID: UUID, message: String, reply: String, emotion: String, timestamp: Date = Date()) {
        self.id = id
        self.$user.id = userID
        self.message = message
        self.reply = reply
        self.emotion = emotion
        self.timestamp = timestamp
    }
} 