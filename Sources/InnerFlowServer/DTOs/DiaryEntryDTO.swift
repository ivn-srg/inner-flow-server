import Vapor

enum DiaryMode: String, Codable, Content {
    case plain, metaphoric, poem, dream, story, analysis
}

enum DiaryEmotion: String, Codable, Content {
    case admiration, amusement, anger, annoyance, approval, caring, confusion, curiosity, desire, disappointment, disapproval, disgust, embarrassment, excitement, fear, gratitude, grief, joy, love, nervousness, optimism, pride, realization, relief, remorse, sadness, surprise, neutral
}

struct DiaryEntryDTO: Content {
    var id: UUID?
    var userId: UUID
    var originalText: String
    var mode: DiaryMode
    var interpretedText: String
    var emotions: [DiaryEmotion]
    var createdAt: Date
} 