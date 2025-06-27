import Vapor

struct DiaryCreateRequest: Content {
    var text: String?
    var mode: DiaryMode
    var voiceUrl: String?
}

struct DiaryCreateResponse: Content {
    var interpretedText: String
    var emotionTags: [DiaryEmotion]
    var summary: String?
} 
