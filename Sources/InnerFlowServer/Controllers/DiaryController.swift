import Vapor
import Fluent

struct DiaryController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let diary = routes.grouped(JWTMiddleware()).grouped("api", "v1", "diary")
        diary.post("create", use: create)
        diary.get("entries", use: entries)
        diary.get("entry", ":id", use: entry)
        diary.delete("entry", ":id", use: delete)
    }

    func create(req: Request) async throws -> DiaryCreateResponse {
        let user = try req.auth.require(User.self)
        let data = try req.content.decode(DiaryCreateRequest.self)
        var text = data.text ?? ""
//        var confidence: Double? = nil
//        var duration: Double? = nil
        if let voiceUrl = data.voiceUrl {
            let result = WhisperTranscriberMock().transcribe(url: voiceUrl)
            text = result.text
//            confidence = result.confidence
//            duration = result.duration
        }
        let emotions = [EmotionAnalyzerMock().analyze(text: text)]
        let (interpreted, summary) = LLMDiaryMock().interpret(text: text, mode: data.mode)
        let entry = DiaryEntry(
            userID: try user.requireID(),
            originalText: text,
            mode: data.mode,
            interpretedText: interpreted,
            emotions: emotions,
            createdAt: Date()
        )
        try await entry.save(on: req.db)
        return DiaryCreateResponse(interpretedText: interpreted, emotionTags: emotions, summary: summary)
    }

    func entries(req: Request) async throws -> [DiaryEntryDTO] {
        let user = try req.auth.require(User.self)
        let entries = try await DiaryEntry.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .sort(\.$createdAt, .descending)
            .limit(50)
            .all()
        return entries.map { entry in
            DiaryEntryDTO(
                id: entry.id,
                userId: entry.$user.id,
                originalText: entry.originalText,
                mode: entry.mode,
                interpretedText: entry.interpretedText,
                emotions: entry.emotions,
                createdAt: entry.createdAt
            )
        }
    }

    func entry(req: Request) async throws -> DiaryEntryDTO {
        let user = try req.auth.require(User.self)
        guard let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) else {
            throw Abort(.badRequest, reason: "Invalid id")
        }
        guard let entry = try await DiaryEntry.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$id == uuid)
            .first() else {
            throw Abort(.notFound)
        }
        return DiaryEntryDTO(
            id: entry.id,
            userId: entry.$user.id,
            originalText: entry.originalText,
            mode: entry.mode,
            interpretedText: entry.interpretedText,
            emotions: entry.emotions,
            createdAt: entry.createdAt
        )
    }

    func delete(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        guard let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) else {
            throw Abort(.badRequest, reason: "Invalid id")
        }
        guard let entry = try await DiaryEntry.query(on: req.db)
            .filter(\.$user.$id == user.requireID())
            .filter(\.$id == uuid)
            .first() else {
            throw Abort(.notFound)
        }
        try await entry.delete(on: req.db)
        return .noContent
    }
} 
