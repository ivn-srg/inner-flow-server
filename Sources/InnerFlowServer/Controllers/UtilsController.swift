import Vapor

struct UtilsController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let utils = routes.grouped("api", "v1", "utils")
        utils.get("emotions", "sample", use: emotionsSample)
        utils.get("modes", use: modes)
    }

    func emotionsSample(req: Request) async throws -> [String] {
        // MOCK: Здесь будет интеграция с GoEmotions
        // TODO: Заменить на реальный список эмоций
        return [
            "admiration", "amusement", "anger", "annoyance", "approval", "caring", "confusion", "curiosity", "desire", "disappointment", "disapproval", "disgust", "embarrassment", "excitement", "fear", "gratitude", "grief", "joy", "love", "nervousness", "optimism", "pride", "realization", "relief", "remorse", "sadness", "surprise", "neutral"
        ]
    }

    func modes(req: Request) async throws -> [String] {
        // MOCK: Здесь будет интеграция с реальными режимами дневника
        // TODO: Заменить на динамический список, если потребуется
        return ["plain", "metaphoric", "poem", "dream", "story", "analysis"]
    }
} 
