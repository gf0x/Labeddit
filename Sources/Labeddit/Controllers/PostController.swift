import Fluent
import Vapor

struct PostController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let posts = routes.grouped("posts")

        posts.get(use: self.index)
        posts.get(":postID", use: self.show)
    }

    @Sendable
    func index(req: Request) async throws -> PostsResponse {
        let limit = (try? req.query.get(Int.self, at: "limit")) ?? 20
        let afterID = try? req.query.get(UUID.self, at: "after")

        var query = Post.query(on: req.db)
            .with(\.$comments)
            .sort(\.$createdAt, .descending)

        if let afterID = afterID {
            guard let afterPost = try await Post.find(afterID, on: req.db) else {
                throw Abort(.badRequest, reason: "Invalid after cursor")
            }
            query = query.filter(\.$createdAt < afterPost.createdAt)
        }

        let posts = try await query
            .limit(limit)
            .all()

        let dtos = posts.map { $0.toDTO() }
        let after = posts.count == limit ? posts.last?.id?.uuidString : nil

        return PostsResponse(posts: dtos, after: after)
    }

    @Sendable
    func show(req: Request) async throws -> PostDTO {
        guard let post = try await Post.find(req.parameters.get("postID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await post.$comments.load(on: req.db)
        return post.toDTO()
    }
}
