@testable import Labeddit
import VaporTesting
import Testing
import Fluent

@Suite("App Tests with DB", .serialized)
struct LabedditTests {
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
            try await test(app)
            try await app.autoRevert()
        } catch {
            try? await app.autoRevert()
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }

    @Test("Test Hello World Route")
    func helloWorld() async throws {
        try await withApp { app in
            try await app.testing().test(.GET, "hello", afterResponse: { res async in
                #expect(res.status == .ok)
                #expect(res.body.string == "Hello, world!")
            })
        }
    }

    @Test("Get all posts returns seeded data")
    func getAllPosts() async throws {
        try await withApp { app in
            try await app.testing().test(.GET, "posts", afterResponse: { res async throws in
                #expect(res.status == .ok)
                let response = try res.content.decode(PostsResponse.self)
                #expect(response.posts.count == 20)
                // Posts should have comments
                let totalComments = response.posts.reduce(0) { $0 + $1.comments.count }
                #expect(totalComments > 0)
            })
        }
    }

    @Test("Get single post by ID")
    func getSinglePost() async throws {
        try await withApp { app in
            let post = try await Post.query(on: app.db).first()!
            let postID = try post.requireID()

            try await app.testing().test(.GET, "posts/\(postID)", afterResponse: { res async throws in
                #expect(res.status == .ok)
                let dto = try res.content.decode(PostDTO.self)
                #expect(dto.id == postID)
                #expect(!dto.title.isEmpty)
            })
        }
    }

    @Test("Pagination with limit")
    func paginationWithLimit() async throws {
        try await withApp { app in
            try await app.testing().test(.GET, "posts?limit=5", afterResponse: { res async throws in
                #expect(res.status == .ok)
                let response = try res.content.decode(PostsResponse.self)
                #expect(response.posts.count == 5)
                #expect(response.after != nil)
            })
        }
    }

    @Test("Pagination with after cursor")
    func paginationWithAfter() async throws {
        try await withApp { app in
            // Get first page
            try await app.testing().test(.GET, "posts?limit=5", afterResponse: { res async throws in
                let firstPage = try res.content.decode(PostsResponse.self)
                let after = try #require(firstPage.after)

                // Get second page
                try await app.testing().test(.GET, "posts?limit=5&after=\(after)", afterResponse: { res async throws in
                    let secondPage = try res.content.decode(PostsResponse.self)
                    #expect(secondPage.posts.count == 5)
                    // No overlap between pages
                    let firstIDs = Set(firstPage.posts.compactMap(\.id))
                    let secondIDs = Set(secondPage.posts.compactMap(\.id))
                    #expect(firstIDs.isDisjoint(with: secondIDs))
                })
            })
        }
    }

    @Test("Post not found returns 404")
    func postNotFound() async throws {
        try await withApp { app in
            let fakeID = UUID()
            try await app.testing().test(.GET, "posts/\(fakeID)", afterResponse: { res async in
                #expect(res.status == .notFound)
            })
        }
    }
}
