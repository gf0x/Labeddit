import Fluent
import Vapor

// Simple seeded RNG so each launch produces different but reproducible-feeling data
private struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed
    }

    mutating func next() -> UInt64 {
        // xorshift64
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}

func seedDatabase(_ app: Application) async throws {
    let count = try await Post.query(on: app.db).count()
    guard count == 0 else { return }

    app.logger.info("Seeding database with generated posts and comments...")

    let now = Date().timeIntervalSince1970
    var rng = SeededRNG(seed: UInt64(now))

    let postCount = 20
    let usernames = [
        "swiftdev42", "appbuilder_jane", "codeMaster99", "ios_mentor",
        "rustacean_ios", "async_await_fan", "vapor_enthusiast", "fullstack_swift",
        "designPatternsPro", "pragmatic_dev", "tca_evangelist", "mvc_defender",
        "accessibility_first", "a11y_advocate", "coredata_survivor", "realm_user",
        "indie_maker", "aspiring_indie", "combine_lover", "reactive_dev",
        "testing_advocate", "tdd_practitioner", "widget_wizard", "metal_renderer",
        "privacy_hawk", "security_minded", "performance_nerd", "visionos_early",
        "localization_pro", "dependency_free", "review_guidelines", "junior_dev_2025",
        "swift_packages", "xcode_cloud_user", "spatial_dev", "skeptical_dev",
    ]

    let domains = [
        "r/iOSProgramming", "r/swift", "r/SwiftUI", "r/apple",
        "r/learnprogramming", "r/iOSDev",
    ]

    let titleTemplates = [
        ("SwiftUI vs UIKit", "Which should you learn first in {year}?"),
        ("Just shipped my first app", "using Swift {version} strict concurrency"),
        ("Server-side Swift with Vapor", "is seriously underrated"),
        ("{pattern} is not the only architecture", "Stop defaulting to it"),
        ("PSA: Test your apps with VoiceOver", "before submitting to the App Store"),
        ("SwiftData is finally ready", "for production (mostly)"),
        ("How I went from $0 to ${revenue} MRR", "as a solo iOS developer"),
        ("Async/Await has made {framework} almost obsolete", "change my mind"),
        ("Swift Testing framework", "is a huge improvement over XCTest"),
        ("Interactive widgets", "changed my app's engagement metrics dramatically"),
        ("Built a real-time {thing} in Metal", "iPhone GPUs are incredible"),
        ("App Tracking Transparency", "reduced our ad revenue by {pct}% - here's what we did"),
        ("CI/CD comparison for iOS", "Xcode Cloud vs GitHub Actions vs Bitrise"),
        ("Stop using CocoaPods in {year}", "SPM has caught up"),
        ("visionOS development", "is like early iOS all over again"),
        ("Instruments tutorial", "How I found and fixed a {ms}ms scroll hitch"),
        ("Please stop storing API keys", "in your iOS app bundles"),
        ("String Catalogs in Xcode", "are amazing for localization"),
        ("Challenge: Build an iOS app", "with zero third-party dependencies"),
        ("App Review rejected my app {n} times", "here's what finally worked"),
        ("Core Animation tricks", "that still work great in {year}"),
        ("My experience with TCA", "after {months} months in production"),
        ("Why I switched from {lang} to Swift", "and never looked back"),
        ("Xcode {version} tips and tricks", "that will save you hours"),
        ("The best WWDC {year} sessions", "you probably missed"),
    ]

    let bodySnippets = [
        "I've been developing iOS apps for {n} years now and wanted to share my experience. ",
        "After weeks of battling compiler warnings, I finally got everything working. ",
        "Built a full REST API in a weekend and was shocked how smooth it was. ",
        "Every tutorial uses the same pattern but there are better alternatives. ",
        "Just reviewed several apps and the results were disappointing. ",
        "After the rocky launch, things have matured significantly. ",
        "Took me {n} months but my app finally hit a revenue milestone. ",
        "With structured concurrency and modern Swift, the old ways feel obsolete. ",
        "The new framework is so much nicer than what we had before. Migration is straightforward. ",
        "Added this feature and user engagement went through the roof. ",
        "Spent {n} months learning from scratch and it was absolutely worth it. ",
        "When the policy change hit, we lost most of our revenue overnight. But we pivoted. ",
        "I've used all the major options extensively and here's my honest comparison. ",
        "There's no good reason to use the old approach anymore in {year}. ",
        "The opportunities remind me of the early App Store days. ",
        "Had a nasty performance issue that took forever to track down. Here's how I did it. ",
        "I decompiled several popular apps and the security issues were alarming. ",
        "Migrated from the old system and the workflow improvement is massive. ",
        "Challenged myself to use only first-party frameworks. It was eye-opening. ",
        "My app kept getting rejected until I figured out what the reviewers actually wanted. ",
    ]

    let bodyEndings = [
        "What do you all think?",
        "Here's what I learned along the way.",
        "Highly recommend trying this approach.",
        "Happy to answer questions about my experience.",
        "Anyone else making the switch?",
        "Am I wrong? Change my mind.",
        "Would love to hear your thoughts.",
        "Has anyone else experienced this?",
        "Let me know if you want a detailed writeup.",
        "The results speak for themselves.",
    ]

    let commentTexts = [
        "Totally agree. Had the same experience myself.",
        "This is great advice, thanks for sharing!",
        "Interesting perspective. I had a different experience though.",
        "Can confirm, switched to this approach last year and it's been great.",
        "How does this compare to {alt}?",
        "The learning curve was steep but worth it in the end.",
        "I honestly didn't know where to start. Any good resources?",
        "We've been doing this for years. Fewer surprises on updates.",
        "Some alternatives genuinely add value though. It depends on the project.",
        "This is the way. Catches so many issues at compile time.",
        "Congrats! The hardest part is definitely getting started.",
        "Works great for small teams. Not sure about enterprise scale though.",
        "At scale, the trade-offs are different. We had to go a different route.",
        "Both approaches are valid. Use whatever makes sense for your project size.",
        "The migration story is still not great, but improving.",
        "This terrifies me as a beginner. Any tips for getting started?",
        "Been doing this for {n} years and still learning new things.",
        "The community support is what makes this approach shine.",
        "I tried this and hit a wall. What am I missing?",
        "Testing alone makes this worth the switch.",
        "Performance is comparable in most cases. The real win is developer experience.",
        "My downloads increased significantly after making this change.",
        "Apple's documentation on this topic is actually really good.",
        "This is underrated advice. More people need to hear this.",
        "Switched from the old way and never looked back.",
    ]

    let alts = ["Realm", "Core Data", "Firebase", "Combine", "RxSwift", "UIKit", "Alamofire", "Express.js", "CocoaPods"]
    let patterns = ["MVVM", "MVC", "TCA", "VIPER", "Clean Architecture"]
    let frameworks = ["Combine", "RxSwift", "PromiseKit", "ReactiveCocoa"]
    let languages = ["JavaScript", "Kotlin", "Python", "Rust", "C++", "Objective-C"]
    let things = ["3D renderer", "particle system", "physics engine", "shader pipeline", "ray tracer"]

    func pick<T>(_ array: [T]) -> T {
        array[Int(rng.next() % UInt64(array.count))]
    }

    func randInt(_ lo: Int, _ hi: Int) -> Int {
        lo + Int(rng.next() % UInt64(hi - lo + 1))
    }

    func fillTemplate(_ s: String) -> String {
        var result = s
        result = result.replacingOccurrences(of: "{year}", with: "\(randInt(2024, 2026))")
        result = result.replacingOccurrences(of: "{version}", with: "\(randInt(5, 6)).\(randInt(0, 2))")
        result = result.replacingOccurrences(of: "{pattern}", with: pick(patterns))
        result = result.replacingOccurrences(of: "{framework}", with: pick(frameworks))
        result = result.replacingOccurrences(of: "{lang}", with: pick(languages))
        result = result.replacingOccurrences(of: "{thing}", with: pick(things))
        result = result.replacingOccurrences(of: "{revenue}", with: "\(randInt(1, 15))k")
        result = result.replacingOccurrences(of: "{pct}", with: "\(randInt(30, 70))")
        result = result.replacingOccurrences(of: "{ms}", with: "\(randInt(100, 500))")
        result = result.replacingOccurrences(of: "{n}", with: "\(randInt(2, 12))")
        result = result.replacingOccurrences(of: "{months}", with: "\(randInt(3, 18))")
        result = result.replacingOccurrences(of: "{alt}", with: pick(alts))
        return result
    }

    for index in 0..<postCount {
        let tmpl = pick(titleTemplates)
        let title = fillTemplate(tmpl.0) + " - " + fillTemplate(tmpl.1)
        let body = fillTemplate(pick(bodySnippets)) + fillTemplate(pick(bodySnippets)) + fillTemplate(pick(bodyEndings))
        let author = pick(usernames)

        let post = Post(
            username: author,
            createdAt: now - Double(index) * Double(randInt(1800, 7200)),
            title: title,
            domain: pick(domains),
            text: body,
            ups: randInt(50, 1500),
            downs: randInt(0, 80),
            imageURL: "https://picsum.photos/seed/post-\(index)/800/600"
        )
        try await post.save(on: app.db)

        let commentCount = randInt(1, 5)
        for _ in 0..<commentCount {
            var commenter = pick(usernames)
            while commenter == author && usernames.count > 1 {
                commenter = pick(usernames)
            }
            let comment = Comment(
                postID: try post.requireID(),
                username: commenter,
                text: fillTemplate(pick(commentTexts)),
                ups: randInt(1, 250),
                downs: randInt(0, 20)
            )
            try await comment.save(on: app.db)
        }
    }

    app.logger.info("Seeded \(postCount) posts with comments.")
}
