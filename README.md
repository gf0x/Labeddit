# Labeddit

A reddit-like REST API built with [Vapor 4](https://vapor.codes) and SQLite, designed as a backend for student iOS lab exercises.

## Features

- **Posts & Comments** — Reddit-style data model with nested comments
- **Auto-seeding** — Database is populated with procedurally generated iOS/Swift-themed posts on first launch
- **Pagination** — Cursor-based pagination with `?after=<post_id>&limit=<n>`
- **Post creation** — `POST /posts` accepts `multipart/form-data` with an optional image upload
- **Image uploads** — Uploaded images are stored in `Public/images/` and served as static files at `/images/<filename>`
- **Placeholder images** — Seeded posts include a deterministic [picsum.photos](https://picsum.photos) image URL

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/r/:subreddit` | Posts for a subreddit. Supports `?limit=` and `?after=` query params |
| `GET` | `/posts/:postID` | Single post with its comments |
| `POST` | `/posts` | Create a new post (see below) |
| `GET` | `/posts` | ⚠️ **Deprecated** — returns all posts without domain filtering. Use `/r/:subreddit` instead. Responds with `Deprecation: true` header. |

Available subreddits in the seeded database: `swift`, `SwiftUI`, `iOSProgramming`, `apple`, `learnprogramming`, `iOSDev`.

### POST /posts

Accepts `multipart/form-data` with the following fields:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | `String` | Yes | Short non-empty post title |
| `text` | `String` | Yes | Post body (any length, non-empty) |
| `username` | `String` | Yes | Author name |
| `image` | `File` | No | Image file (jpg, jpeg, png, gif, webp, heic) |

Returns the created post as a `PostDTO`. The `image_url` field will be `""` if no image was attached, or `/images/<uuid>.<ext>` if one was uploaded. Prepend the server base URL to get the full image URL.

**Example response:**
```json
{
  "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "username": "student42",
  "created_at": 1742300000.0,
  "title": "My first post",
  "domain": "user.post",
  "text": "Hello from the iOS app!",
  "ups": 0,
  "downs": 0,
  "image_url": "/images/9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d.jpg",
  "comments": []
}
```

## Getting Started

```bash
# Build
swift build

# Run (starts on http://localhost:8080)
swift run

# Test
swift test
```

On first run the database (`db.sqlite`) is created and seeded automatically. Delete `db.sqlite` to re-seed with fresh generated data.

## Postman Collection

A ready-made Postman collection is included at [`Labeddit.postman_collection.json`](Labeddit.postman_collection.json). Import it into Postman to manually test all endpoints. The requests are ordered so that running "Get All Posts" first will auto-populate variables (`postId`, `afterCursor`) used by subsequent requests.

## Tech Stack

- [Vapor 4](https://vapor.codes) — Server-side Swift web framework
- [Fluent](https://docs.vapor.codes/fluent/overview/) — ORM with SQLite driver
- [Swift Testing](https://developer.apple.com/documentation/testing) — Test framework

## License

This project is licensed under the [Creative Commons Attribution 4.0 International License (CC BY 4.0)](LICENSE).
