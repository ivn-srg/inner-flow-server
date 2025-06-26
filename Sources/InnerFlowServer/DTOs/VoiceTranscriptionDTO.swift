import Vapor

struct VoiceTranscriptionDTO: Content {
    var id: UUID?
    var userId: UUID
    var status: String
    var text: String?
    var confidence: Double?
    var duration: Double?
    var fileURL: String
    var createdAt: Date
} 