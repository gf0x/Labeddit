# Labeddit

A reddit-like REST API built with [Vapor 4](https://vapor.codes) and SQLite, designed as a backend for student iOS lab exercises.

## Features

- **Posts & Comments** — Reddit-style data model with nested comments
- **Auto-seeding** — Database is populated with procedurally generated iOS/Swift-themed posts on first launch
- **Pagination** — Cursor-based pagination with `?after=<post_id>&limit=<n>`
- **Placeholder images** — Each post includes a deterministic [picsum.photos](https://picsum.photos) image URL

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/posts` | All posts with nested comments. Supports `?limit=` and `?after=` query params |
| `GET` | `/posts/:postID` | Single post with its comments |

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
