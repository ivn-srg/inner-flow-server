import Fluent
import Vapor

final class DiaryEntry: Model, Content, @unchecked Sendable {
    static let schema = "diary_entries"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "original_text")
    var originalText: String

    @Field(key: "mode")
    var mode: DiaryMode

    @Field(key: "interpreted_text")
    var interpretedText: String

    @Field(key: "emotions")
    var emotions: [DiaryEmotion]

    @Field(key: "created_at")
    var createdAt: Date

    init() { }

    init(id: UUID? = nil, userID: UUID, originalText: String, mode: DiaryMode, interpretedText: String, emotions: [DiaryEmotion], createdAt: Date = Date()) {
        self.id = id
        self.$user.id = userID
        self.originalText = originalText
        self.mode = mode
        self.interpretedText = interpretedText
        self.emotions = emotions
        self.createdAt = createdAt
    }
} 