import Vapor

struct VoiceTranscribeResponse: Content {
    var id: UUID
}

struct VoiceCheckResponse: Content {
    var id: UUID
    var status: String
    var text: String?
    var confidence: Double?
    var duration: Double?
} 