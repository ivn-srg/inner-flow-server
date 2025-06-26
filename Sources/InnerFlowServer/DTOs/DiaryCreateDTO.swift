import Vapor

struct DiaryCreateRequest: Content {
    var text: String?
    var mode: String
    var voiceUrl: String?
}

struct DiaryCreateResponse: Content {
    var interpretedText: String
    var emotionTags: [String]
    var summary: String?
} 
