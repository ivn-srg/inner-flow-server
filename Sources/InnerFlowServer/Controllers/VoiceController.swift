import Vapor
import Fluent

struct VoiceController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let voice = routes.grouped(JWTMiddleware()).grouped("api", "v1", "voice")
        voice.post("transcribe", use: transcribe)
        voice.get("check", ":id", use: check)
    }

    func transcribe(req: Request) async throws -> VoiceTranscribeResponse {
        let user = try req.auth.require(User.self)
        // В реальном API: req.body.collect или multipart
        // Здесь mock: просто создаём задачу и сразу "обрабатываем"
        let fileURL = "mock_url.m4a" // TODO: получить реальный url файла
        let transcription = VoiceTranscription(
            userID: try user.requireID(),
            status: .processing,
            text: nil,
            confidence: nil,
            duration: nil,
            fileURL: fileURL,
            createdAt: Date()
        )
        try await transcription.save(on: req.db)
        // MOCK: сразу "обрабатываем" задачу
        let result = WhisperTranscriberMock().transcribe(url: fileURL)
        transcription.status = .done
        transcription.text = result.text
        transcription.confidence = result.confidence
        transcription.duration = result.duration
        try await transcription.save(on: req.db)
        return VoiceTranscribeResponse(id: try transcription.requireID())
    }

    func check(req: Request) async throws -> VoiceCheckResponse {
        let user = try req.auth.require(User.self)
        guard let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) else {
            throw Abort(.badRequest, reason: "Invalid id")
        }
        guard let transcription = try await VoiceTranscription.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$id == uuid)
            .first() else {
            throw Abort(.notFound)
        }
        return VoiceCheckResponse(
            id: try transcription.requireID(),
            status: transcription.status.rawValue,
            text: transcription.text,
            confidence: transcription.confidence,
            duration: transcription.duration
        )
    }
} 
