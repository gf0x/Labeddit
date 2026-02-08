import Vapor

struct CommentDTO: Content {
    var id: UUID?
    var postID: UUID?
    var username: String
    var text: String
    var ups: Int
    var downs: Int

    enum CodingKeys: String, CodingKey {
        case id, username, text, ups, downs
        case postID = "post_id"
    }
}
