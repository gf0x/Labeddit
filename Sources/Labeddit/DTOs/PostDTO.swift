import Vapor

struct PostDTO: Content {
    var id: UUID?
    var username: String
    var createdAt: Double
    var title: String
    var domain: String
    var text: String
    var ups: Int
    var downs: Int
    var imageURL: String
    var comments: [CommentDTO]

    enum CodingKeys: String, CodingKey {
        case id, username, title, domain, text, ups, downs, comments
        case createdAt = "created_at"
        case imageURL = "image_url"
    }
}

struct PostsResponse: Content {
    var posts: [PostDTO]
    var after: String?
}
