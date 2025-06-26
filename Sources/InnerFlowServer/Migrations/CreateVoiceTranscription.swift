import Fluent

struct CreateVoiceTranscription: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("voice_transcriptions")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("status", .string, .required)
            .field("text", .string)
            .field("confidence", .double)
            .field("duration", .double)
            .field("file_url", .string, .required)
            .field("created_at", .datetime, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("voice_transcriptions").delete()
    }
} 