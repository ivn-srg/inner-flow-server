import Foundation

final class LLMChatMock {
    func generateReply(userMessage: String, emotion: String) -> String {
        // MOCK: Здесь будет интеграция с LLM (Ollama/Mistral)
        // TODO: Заменить на реальный вызов LLM
        return "[LLM-ответ] Я понял твои чувства: \(emotion). Давай обсудим это."
    }
} 