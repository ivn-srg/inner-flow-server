import Fluent

struct CreateChatMessage: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("chat_messages")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("message", .string, .required)
            .field("reply", .string, .required)
            .field("emotion", .string, .required)
            .field("timestamp", .datetime, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("chat_messages").delete()
    }
} 