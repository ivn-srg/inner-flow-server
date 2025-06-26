import Foundation

final class WhisperTranscriberMock {
    func transcribe(url: String) -> (text: String, confidence: Double, duration: Double) {
        // MOCK: Здесь будет интеграция с Whisper
        // TODO: Заменить на реальный вызов Whisper
        return ("Транскрибированный текст из аудио", 0.95, 12.3)
    }
} 