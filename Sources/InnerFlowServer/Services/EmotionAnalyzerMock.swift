import Foundation

final class EmotionAnalyzerMock {
    func analyze(text: String) -> String {
        // MOCK: Здесь будет интеграция с GoEmotions
        // TODO: Заменить на реальный вызов GoEmotions
        let emotions = ["anxiety", "calm", "anger", "joy", "sadness"]
        return emotions.randomElement() ?? "neutral"
    }
} 