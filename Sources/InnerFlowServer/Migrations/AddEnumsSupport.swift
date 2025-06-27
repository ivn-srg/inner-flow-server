import Fluent

struct AddEnumsSupport: AsyncMigration {
    func prepare(on database: any Database) async throws {
        // DiaryEntry: mode, emotions
        try await database.schema("diary_entries")
            .deleteField("mode")
            .deleteField("emotions")
            .field("mode", .string, .required)
            .field("emotions", .array(of: .string), .required)
            .update()
        // ChatMessage: emotion
        try await database.schema("chat_messages")
            .deleteField("emotion")
            .field("emotion", .string, .required)
            .update()
        // VoiceTranscription: status
        try await database.schema("voice_transcriptions")
            .deleteField("status")
            .field("status", .string, .required)
            .update()
        // User: gender
        try await database.schema("users")
            .deleteField("gender")
            .field("gender", .string, .required)
            .update()
        // UserSettings (in users.settings): tone, language — остаются в json, но теперь значения должны быть валидными строками enum
    }
    func revert(on database: any Database) async throws {
        // Откат: вернуть старые поля (если нужно)
        try await database.schema("diary_entries")
            .deleteField("mode")
            .deleteField("emotions")
            .field("mode", .string, .required)
            .field("emotions", .array(of: .string), .required)
            .update()
        try await database.schema("chat_messages")
            .deleteField("emotion")
            .field("emotion", .string, .required)
            .update()
        try await database.schema("voice_transcriptions")
            .deleteField("status")
            .field("status", .string, .required)
            .update()
        try await database.schema("users")
            .deleteField("gender")
            .field("gender", .string, .required)
            .update()
    }
} 
