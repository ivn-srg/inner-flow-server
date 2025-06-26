import Foundation

final class LLMDiaryMock {
    func interpret(text: String, mode: String) -> (interpreted: String, summary: String?) {
        // MOCK: Здесь будет интеграция с LLM (GPT-NeoX и др.)
        // TODO: Заменить на реальный вызов LLM
        let interp = "[LLM-интерпретация] \(mode): \(text)"
        let summary = "[LLM-резюме] Краткое содержание записи."
        return (interp, summary)
    }
} 