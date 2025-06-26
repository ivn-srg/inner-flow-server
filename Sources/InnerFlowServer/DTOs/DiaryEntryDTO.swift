import Vapor

struct DiaryEntryDTO: Content {
    var id: UUID?
    var userId: UUID
    var originalText: String
    var mode: String
    var interpretedText: String
    var emotions: [String]
    var createdAt: Date
} 