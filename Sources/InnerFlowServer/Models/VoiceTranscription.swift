import Fluent
import Vapor

final class VoiceTranscription: Model, Content, @unchecked Sendable {
    static let schema = "voice_transcriptions"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "status")
    var status: VoiceTranscriptionStatus

    @Field(key: "text")
    var text: String?

    @Field(key: "confidence")
    var confidence: Double?

    @Field(key: "duration")
    var duration: Double?

    @Field(key: "file_url")
    var fileURL: String

    @Field(key: "created_at")
    var createdAt: Date

    init() { }

    init(id: UUID? = nil, userID: UUID, status: VoiceTranscriptionStatus = .pending, text: String? = nil, confidence: Double? = nil, duration: Double? = nil, fileURL: String, createdAt: Date = Date()) {
        self.id = id
        self.$user.id = userID
        self.status = status
        self.text = text
        self.confidence = confidence
        self.duration = duration
        self.fileURL = fileURL
        self.createdAt = createdAt
    }
} 