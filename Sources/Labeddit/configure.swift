import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor
import Leaf
import Foundation

// configures your application
public func configure(_ app: Application) async throws {
    app.views.use(.leaf)

    // Serve static files from /Public folder (for uploaded images)
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Allow up to 10 MB for multipart image uploads
    app.routes.defaultMaxBodySize = "10mb"

    // Ensure the images upload directory exists
    let imagesDir = app.directory.publicDirectory + "images"
    try FileManager.default.createDirectory(atPath: imagesDir, withIntermediateDirectories: true)

    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreatePost())
    app.migrations.add(CreateComment())

    try await app.autoMigrate()
    try await seedDatabase(app)

    // register routes
    try routes(app)
}
