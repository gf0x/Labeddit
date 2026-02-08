import Fluent

struct CreatePost: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("posts")
            .id()
            .field("username", .string, .required)
            .field("created_at", .double, .required)
            .field("title", .string, .required)
            .field("domain", .string, .required)
            .field("text", .string, .required)
            .field("ups", .int, .required)
            .field("downs", .int, .required)
            .field("image_url", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("posts").delete()
    }
}
