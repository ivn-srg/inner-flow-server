import Vapor

enum VoiceTranscriptionStatus: String, Codable, Content {
    case pending, processing, done, error
}

struct VoiceTranscriptionDTO: Content {
    var id: UUID?
    var userId: UUID
    var status: VoiceTranscriptionStatus
    var text: String?
    var confidence: Double?
    var duration: Double?
    var fileURL: String
    var createdAt: Date
} 