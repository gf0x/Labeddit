import Fluent
import struct Foundation.UUID

final class Comment: Model, @unchecked Sendable {
    static let schema = "comments"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "post_id")
    var post: Post

    @Field(key: "username")
    var username: String

    @Field(key: "text")
    var text: String

    @Field(key: "ups")
    var ups: Int

    @Field(key: "downs")
    var downs: Int

    init() {}

    init(
        id: UUID? = nil,
        postID: UUID,
        username: String,
        text: String,
        ups: Int,
        downs: Int
    ) {
        self.id = id
        self.$post.id = postID
        self.username = username
        self.text = text
        self.ups = ups
        self.downs = downs
    }

    func toDTO() -> CommentDTO {
        .init(
            id: self.id,
            postID: self.$post.id,
            username: self.username,
            text: self.text,
            ups: self.ups,
            downs: self.downs
        )
    }
}
