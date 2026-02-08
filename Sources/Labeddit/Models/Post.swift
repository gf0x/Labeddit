import Fluent
import struct Foundation.UUID

final class Post: Model, @unchecked Sendable {
    static let schema = "posts"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "username")
    var username: String

    @Field(key: "created_at")
    var createdAt: Double

    @Field(key: "title")
    var title: String

    @Field(key: "domain")
    var domain: String

    @Field(key: "text")
    var text: String

    @Field(key: "ups")
    var ups: Int

    @Field(key: "downs")
    var downs: Int

    @Field(key: "image_url")
    var imageURL: String

    @Children(for: \.$post)
    var comments: [Comment]

    init() {}

    init(
        id: UUID? = nil,
        username: String,
        createdAt: Double,
        title: String,
        domain: String,
        text: String,
        ups: Int,
        downs: Int,
        imageURL: String
    ) {
        self.id = id
        self.username = username
        self.createdAt = createdAt
        self.title = title
        self.domain = domain
        self.text = text
        self.ups = ups
        self.downs = downs
        self.imageURL = imageURL
    }

    func toDTO() -> PostDTO {
        .init(
            id: self.id,
            username: self.username,
            createdAt: self.createdAt,
            title: self.title,
            domain: self.domain,
            text: self.text,
            ups: self.ups,
            downs: self.downs,
            imageURL: self.imageURL,
            comments: (self.$comments.value ?? []).map { $0.toDTO() }
        )
    }
}
