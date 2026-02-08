import Fluent

struct CreateComment: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("comments")
            .id()
            .field("post_id", .uuid, .required, .references("posts", "id", onDelete: .cascade))
            .field("username", .string, .required)
            .field("text", .string, .required)
            .field("ups", .int, .required)
            .field("downs", .int, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("comments").delete()
    }
}
