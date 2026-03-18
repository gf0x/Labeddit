import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor
import Leaf
import Foundation

// configures your application
public func configure(_ app: Application, workingDirectory: String = #filePath) async throws {
    // Pin the working directory to the project root using the compile-time path of this
    // source file. This ensures Leaf and FileMiddleware find their directories regardless
    // of where the binary is launched from (terminal, Xcode, CI, etc.).
    let projectRoot = URL(fileURLWithPath: workingDirectory)
        .deletingLastPathComponent()  // Sources/Labeddit/
        .deletingLastPathComponent()  // Sources/
        .deletingLastPathComponent()  // project root
        .path + "/"
    app.directory = DirectoryConfiguration(workingDirectory: projectRoot)

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
