import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class LLMChatMock {
    func generateReply(userMessage: String, emotion: String) async throws -> String {
        // Формируем сообщения для Mistral
        let messages: [[String: String]] = [
            ["role": "user", "content": userMessage + " (emotion: " + emotion + ")"]
        ]
        let url = URL(string: "http://mistral:8001/generate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = try JSONSerialization.data(withJSONObject: ["messages": messages], options: [])
        request.httpBody = body
        request.timeoutInterval = 30 // 30 секунд таймаут
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return "[Ошибка LLM: неверный ответ от сервиса]"
            }
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return (json?["result"] as? String) ?? "[Ошибка LLM: пустой ответ]"
        } catch {
            return "[Ошибка LLM: \(error.localizedDescription)]"
        }
    }
} 