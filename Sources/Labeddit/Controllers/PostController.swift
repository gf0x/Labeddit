import Fluent
import Vapor
import Foundation

struct PostController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let posts = routes.grouped("posts")

        posts.get(use: self.index)
        posts.get(":postID", use: self.show)
        posts.post(use: self.create)
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

    @Sendable
    func create(req: Request) async throws -> PostDTO {
        let input = try req.content.decode(CreatePostRequest.self)

        guard !input.title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw Abort(.badRequest, reason: "Title cannot be empty")
        }
        guard !input.text.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw Abort(.badRequest, reason: "Text cannot be empty")
        }
        guard !input.username.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw Abort(.badRequest, reason: "Username cannot be empty")
        }

        var imageURL = ""

        if let file = input.image, file.data.readableBytes > 0 {
            let ext = (file.filename as NSString).pathExtension.lowercased()
            let validExtensions = ["jpg", "jpeg", "png", "gif", "webp", "heic"]
            let safeExt = validExtensions.contains(ext) ? ext : "jpg"

            let filename = "\(UUID().uuidString).\(safeExt)"
            let imagesDir = req.application.directory.publicDirectory + "images/"
            let filePath = imagesDir + filename

            var buffer = file.data
            guard let data = buffer.readData(length: buffer.readableBytes) else {
                throw Abort(.internalServerError, reason: "Failed to read uploaded file")
            }
            try data.write(to: URL(fileURLWithPath: filePath))

            imageURL = "/images/\(filename)"
        }

        let post = Post(
            username: input.username,
            createdAt: Date().timeIntervalSince1970,
            title: input.title,
            domain: "user.post",
            text: input.text,
            ups: 0,
            downs: 0,
            imageURL: imageURL
        )

        try await post.save(on: req.db)
        return post.toDTO()
    }
}

struct CreatePostRequest: Content {
    var title: String
    var text: String
    var username: String
    var image: File?
}
