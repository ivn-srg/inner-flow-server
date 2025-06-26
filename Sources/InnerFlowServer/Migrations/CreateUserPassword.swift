import Fluent

struct CreateUserPassword: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("user_passwords")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("password_hash", .string, .required)
            .unique(on: "user_id")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("user_passwords").delete()
    }
} 