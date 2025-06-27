import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("users")
            .id()
            .field("email", .string, .required)
            .field("name", .string, .required)
            .field("gender", .string, .required)
            .field("age", .int32, .required)
            .field("created_at", .datetime, .required)
            .field("settings", .json, .required)
            .unique(on: "email")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("users").delete()
    }
} 