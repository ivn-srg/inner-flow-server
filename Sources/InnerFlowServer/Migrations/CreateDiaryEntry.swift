import Fluent

struct CreateDiaryEntry: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("diary_entries")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("original_text", .string, .required)
            .field("mode", .string, .required)
            .field("interpreted_text", .string, .required)
            .field("emotions", .array(of: .string), .required)
            .field("created_at", .datetime, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("diary_entries").delete()
    }
} 