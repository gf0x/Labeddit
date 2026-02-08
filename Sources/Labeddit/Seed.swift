import Fluent
import Vapor

func seedDatabase(_ app: Application) async throws {
    let count = try await Post.query(on: app.db).count()
    guard count == 0 else { return }

    app.logger.info("Seeding database with sample posts and comments...")

    let now = Date().timeIntervalSince1970

    let posts: [(username: String, title: String, domain: String, text: String, ups: Int, downs: Int, seed: String, comments: [(username: String, text: String, ups: Int, downs: Int)])] = [
        (
            username: "swiftdev42",
            title: "SwiftUI vs UIKit in 2025 - Which should you learn first?",
            domain: "r/iOSProgramming",
            text: "I've been developing iOS apps for 3 years now and I still think UIKit knowledge is essential. SwiftUI is great for new projects but understanding the underlying UIKit concepts makes you a much better developer. What do you all think?",
            ups: 342, downs: 12, seed: "swiftui-uikit",
            comments: [
                (username: "appbuilder_jane", text: "Totally agree. I started with SwiftUI and hit a wall when I needed to customize things that SwiftUI doesn't support yet.", ups: 89, downs: 2),
                (username: "codeMaster99", text: "SwiftUI first, UIKit when needed. No point learning the old way if you're starting fresh in 2025.", ups: 67, downs: 15),
                (username: "ios_mentor", text: "Both. Learn SwiftUI for the declarative paradigm, UIKit for when you need fine-grained control. They complement each other.", ups: 124, downs: 3),
            ]
        ),
        (
            username: "rustacean_ios",
            title: "Just shipped my first app using Swift 6 strict concurrency",
            domain: "r/swift",
            text: "After weeks of battling Sendable warnings, my app finally compiles with strict concurrency enabled. The actor isolation model is brilliant once it clicks. Here's what I learned...",
            ups: 567, downs: 23, seed: "swift6-concurrency",
            comments: [
                (username: "async_await_fan", text: "Congrats! The Sendable warnings were brutal for me too. Did you use @MainActor a lot?", ups: 45, downs: 1),
                (username: "thread_safety_first", text: "This is the way. Strict concurrency catches so many potential data races at compile time.", ups: 78, downs: 4),
            ]
        ),
        (
            username: "vapor_enthusiast",
            title: "Server-side Swift with Vapor is seriously underrated",
            domain: "r/swift",
            text: "Built a full REST API with Vapor 4 in a weekend. If you already know Swift, the learning curve is minimal. Fluent ORM is great and the async/await support is first class. Highly recommend for iOS devs who want to build their own backends.",
            ups: 289, downs: 8, seed: "vapor-server-swift",
            comments: [
                (username: "fullstack_swift", text: "I use Vapor for all my personal projects now. Sharing models between iOS app and backend is a game changer.", ups: 56, downs: 2),
                (username: "node_convert", text: "Switched from Express.js to Vapor. The type safety alone was worth it.", ups: 43, downs: 7),
                (username: "cloud_deployer", text: "How's the deployment story? I've been hesitant because of hosting options for Swift.", ups: 31, downs: 1),
                (username: "vapor_enthusiast", text: "Railway and Fly.io both work great. Docker makes it easy.", ups: 28, downs: 0),
            ]
        ),
        (
            username: "designPatternsPro",
            title: "MVVM is not the only architecture - Stop defaulting to it",
            domain: "r/iOSProgramming",
            text: "Every iOS tutorial uses MVVM but there are so many other great patterns. TCA (The Composable Architecture) has completely changed how I think about state management. Clean Architecture with coordinators is also amazing for larger apps.",
            ups: 445, downs: 67, seed: "mvvm-architecture",
            comments: [
                (username: "mvc_defender", text: "MVC isn't even that bad if you do it right. Apple's sample code uses it for a reason.", ups: 112, downs: 34),
                (username: "tca_evangelist", text: "TCA + SwiftUI is the best combo I've ever used. Testing is a breeze.", ups: 87, downs: 12),
                (username: "pragmatic_dev", text: "Use whatever makes sense for your project size. A todo app doesn't need Clean Architecture.", ups: 203, downs: 5),
            ]
        ),
        (
            username: "accessibility_first",
            title: "PSA: Test your apps with VoiceOver before submitting",
            domain: "r/iOSProgramming",
            text: "Just reviewed 10 apps from this subreddit and only 2 had proper VoiceOver support. Accessibility isn't optional - it's required by law in many countries and it's just the right thing to do. SwiftUI makes it easy with .accessibilityLabel and .accessibilityHint.",
            ups: 891, downs: 4, seed: "voiceover-a11y",
            comments: [
                (username: "a11y_advocate", text: "Thank you for posting this! Dynamic Type support is also crucial. Test with the largest text size.", ups: 156, downs: 0),
                (username: "junior_dev_2025", text: "I honestly didn't know where to start with accessibility. Any good resources?", ups: 34, downs: 0),
                (username: "accessibility_first", text: "Apple's WWDC sessions on accessibility are the best starting point. Also check out Rob Whitaker's book.", ups: 67, downs: 0),
            ]
        ),
        (
            username: "coredata_survivor",
            title: "SwiftData is finally ready for production (mostly)",
            domain: "r/swift",
            text: "After the rocky launch, SwiftData has matured significantly. I just migrated a Core Data app with 50k+ records and it went smoothly. CloudKit sync still has some edge cases but for local storage it's solid now.",
            ups: 234, downs: 19, seed: "swiftdata-production",
            comments: [
                (username: "realm_user", text: "How does it compare to Realm in terms of performance?", ups: 23, downs: 2),
                (username: "coredata_survivor", text: "Comparable for most operations. The big win is the API simplicity and native Swift integration.", ups: 45, downs: 1),
                (username: "migration_nightmare", text: "The migration story is still not great. Had to write custom migration code for schema changes.", ups: 56, downs: 3),
            ]
        ),
        (
            username: "indie_maker",
            title: "How I went from $0 to $5k MRR as a solo iOS developer",
            domain: "r/iOSProgramming",
            text: "Took me 18 months but my niche productivity app finally hit $5k MRR. Key lessons: solve your own problem, ship fast, iterate based on reviews, and invest in ASO. Happy to answer questions about the journey.",
            ups: 1203, downs: 31, seed: "indie-dev-revenue",
            comments: [
                (username: "aspiring_indie", text: "This is so inspiring! What's your tech stack?", ups: 67, downs: 0),
                (username: "indie_maker", text: "SwiftUI + CloudKit + RevenueCat. Kept it simple.", ups: 89, downs: 1),
                (username: "marketing_dev", text: "ASO is seriously underrated. My downloads 3x'd after optimizing keywords.", ups: 45, downs: 2),
                (username: "burnout_recovery", text: "How do you handle the stress of being solo? I burned out after 6 months.", ups: 78, downs: 0),
                (username: "indie_maker", text: "Strict work hours and taking weekends off. The app can wait.", ups: 134, downs: 0),
            ]
        ),
        (
            username: "combine_lover",
            title: "Async/Await has made Combine almost obsolete - change my mind",
            domain: "r/swift",
            text: "With structured concurrency, AsyncSequence, and the new Observable macro, I can't think of a reason to use Combine in new code. Am I wrong?",
            ups: 378, downs: 89, seed: "combine-async-await",
            comments: [
                (username: "reactive_dev", text: "Combine still has operators like debounce, throttle, combineLatest that are more ergonomic than their async equivalents.", ups: 156, downs: 12),
                (username: "swift_evolution", text: "AsyncAlgorithms package is filling those gaps. Give it another year.", ups: 87, downs: 8),
            ]
        ),
        (
            username: "testing_advocate",
            title: "Swift Testing framework is a huge improvement over XCTest",
            domain: "r/swift",
            text: "The new Swift Testing framework with #expect macros, parameterized tests, and traits is so much nicer than XCTest. Migration is straightforward too. Anyone else making the switch?",
            ups: 267, downs: 7, seed: "swift-testing",
            comments: [
                (username: "tdd_practitioner", text: "The parameterized tests alone are worth the switch. No more copy-pasting test methods.", ups: 78, downs: 1),
                (username: "ci_engineer", text: "Works great with Xcode Cloud too. The parallel test execution is noticeably faster.", ups: 45, downs: 0),
                (username: "legacy_codebase", text: "We have 3000 XCTests. The incremental migration path is nice - both frameworks coexist.", ups: 34, downs: 0),
            ]
        ),
        (
            username: "widget_wizard",
            title: "Interactive widgets changed my app's engagement metrics dramatically",
            domain: "r/iOSProgramming",
            text: "Added interactive widgets to my habit tracker app and daily active users went up 40%. Users love being able to check off habits right from the home screen. The App Intents framework makes it relatively painless.",
            ups: 456, downs: 11, seed: "interactive-widgets",
            comments: [
                (username: "widget_newbie", text: "Any gotchas with the timeline refresh? My widget data gets stale.", ups: 34, downs: 0),
                (username: "widget_wizard", text: "Use relevance-based timeline and invalidate from your main app when data changes. Also budget your refreshes wisely.", ups: 56, downs: 1),
            ]
        ),
        (
            username: "metal_renderer",
            title: "Built a real-time 3D renderer in Metal - it's incredible what iPhone GPUs can do",
            domain: "r/iOSProgramming",
            text: "Spent 3 months learning Metal from scratch. The A17 Pro chip handles PBR lighting with 1M+ triangles at 60fps no problem. If you're interested in graphics programming on iOS, Metal is absolutely worth learning.",
            ups: 678, downs: 5, seed: "metal-3d-render",
            comments: [
                (username: "gamedev_swift", text: "This is awesome! Did you use MetalKit or build your own rendering pipeline?", ups: 45, downs: 0),
                (username: "metal_renderer", text: "Started with MetalKit for bootstrapping, then moved to a custom pipeline for more control. MSL (Metal Shading Language) is fun once you get the hang of it.", ups: 67, downs: 0),
                (username: "opengl_veteran", text: "Metal's API is so much cleaner than OpenGL ES was. Apple really nailed the modern GPU API design.", ups: 89, downs: 3),
            ]
        ),
        (
            username: "privacy_hawk",
            title: "App Tracking Transparency reduced our ad revenue by 60% - here's what we did",
            domain: "r/iOSProgramming",
            text: "When ATT hit, our ad-supported app lost most of its revenue overnight. We pivoted to a freemium model with a subscription and are now making 2x what we were before. Privacy-first is actually better for business long term.",
            ups: 534, downs: 22, seed: "att-privacy",
            comments: [
                (username: "ad_tech_dev", text: "Same experience here. Contextual ads and subscriptions are the way forward.", ups: 78, downs: 4),
                (username: "privacy_hawk", text: "Users actually trust our app more now that we don't track them. Reviews improved too.", ups: 123, downs: 2),
            ]
        ),
        (
            username: "xcode_cloud_user",
            title: "CI/CD comparison: Xcode Cloud vs GitHub Actions vs Bitrise for iOS",
            domain: "r/iOSProgramming",
            text: "I've used all three extensively. Xcode Cloud is simplest for pure iOS projects, GitHub Actions is most flexible, and Bitrise has the best pre-built iOS workflows. Here's my detailed comparison after 6 months with each.",
            ups: 389, downs: 14, seed: "cicd-comparison",
            comments: [
                (username: "devops_ios", text: "Fastlane + GitHub Actions is my go-to. The ecosystem and community support is unmatched.", ups: 67, downs: 5),
                (username: "small_team_lead", text: "Xcode Cloud's free tier is generous enough for small teams. 25 compute hours/month.", ups: 45, downs: 1),
                (username: "enterprise_dev", text: "At scale, self-hosted runners are the way to go. We saved 70% on CI costs.", ups: 56, downs: 8),
            ]
        ),
        (
            username: "swift_packages",
            title: "Stop using CocoaPods in 2025 - SPM has caught up",
            domain: "r/swift",
            text: "Unpopular opinion: there's no good reason to start a new project with CocoaPods anymore. SPM handles binary frameworks, resources, and plugins now. The only exception is if a library you absolutely need doesn't support SPM yet.",
            ups: 412, downs: 78, seed: "spm-cocoapods",
            comments: [
                (username: "cocoapods_maintainer", text: "SPM still doesn't handle mixed-language targets well. For ObjC heavy projects, CocoaPods is still necessary.", ups: 89, downs: 12),
                (username: "modern_swift_dev", text: "Haven't used CocoaPods in 2 years. SPM + Swift packages only. Life is good.", ups: 67, downs: 8),
                (username: "pragmatic_lead", text: "We migrated 40+ pods to SPM last quarter. Took 2 weeks but build times improved 30%.", ups: 134, downs: 3),
            ]
        ),
        (
            username: "visionos_early",
            title: "visionOS development is like early iOS all over again",
            domain: "r/iOSProgramming",
            text: "Been developing for Vision Pro since launch. The opportunities remind me of the early App Store days. The platform is new, competition is low, and Apple is actively promoting good apps. If you know SwiftUI, the learning curve isn't steep.",
            ups: 567, downs: 34, seed: "visionos-dev",
            comments: [
                (username: "spatial_dev", text: "RealityKit + SwiftUI is a really fun combo. Building 3D UIs feels like the future.", ups: 89, downs: 2),
                (username: "skeptical_dev", text: "The install base is tiny though. Is it worth the investment right now?", ups: 78, downs: 6),
                (username: "visionos_early", text: "That's exactly what people said about iPhone in 2008. Get in early.", ups: 123, downs: 15),
                (username: "ar_researcher", text: "The hand tracking and eye tracking APIs are incredible. Spatial computing is legit.", ups: 45, downs: 1),
            ]
        ),
        (
            username: "performance_nerd",
            title: "Instruments tutorial: How I found and fixed a 200ms scroll hitch",
            domain: "r/iOSProgramming",
            text: "Had a nasty scroll performance issue in a collection view. Used Time Profiler and discovered a synchronous image decode on the main thread buried 5 layers deep in a third-party library. Here's a step-by-step guide to finding these issues.",
            ups: 723, downs: 8, seed: "instruments-perf",
            comments: [
                (username: "smooth_scroll", text: "Instruments is so powerful but so intimidating. Thanks for the walkthrough!", ups: 89, downs: 0),
                (username: "performance_nerd", text: "Start with Time Profiler and Animation Hitches template. Those two cover 90% of performance issues.", ups: 112, downs: 1),
                (username: "junior_debugger", text: "TIL about the Animation Hitches template. Game changer for scrolling issues.", ups: 45, downs: 0),
            ]
        ),
        (
            username: "security_minded",
            title: "Please stop storing API keys in your iOS app bundles",
            domain: "r/iOSProgramming",
            text: "I decompiled 5 popular apps today and found plaintext API keys in 3 of them. Use a backend proxy, CloudKit, or at minimum obfuscate your keys. Anyone with a $99 Apple developer account can extract your IPA and find hardcoded secrets.",
            ups: 945, downs: 6, seed: "api-key-security",
            comments: [
                (username: "backend_proxy", text: "Always proxy through your own server. The client should never hold sensitive keys.", ups: 234, downs: 1),
                (username: "obfuscation_fan", text: "At minimum use compile-time obfuscation. It won't stop determined attackers but raises the bar.", ups: 67, downs: 12),
                (username: "security_minded", text: "Obfuscation is security through obscurity. Backend proxy is the only real solution.", ups: 145, downs: 3),
                (username: "firebase_user", text: "What about Firebase API keys? Google says they're safe to include in client apps.", ups: 56, downs: 2),
                (username: "security_minded", text: "Firebase keys are restricted by bundle ID and security rules. That's different from secret API keys with full access.", ups: 89, downs: 0),
            ]
        ),
        (
            username: "localization_pro",
            title: "String Catalogs in Xcode 15+ are amazing - finally a good localization workflow",
            domain: "r/iOSProgramming",
            text: "Migrated from .strings files to String Catalogs and the workflow improvement is massive. Automatic extraction, visual editor, pluralization support, and it works with SwiftUI out of the box. If you're still using NSLocalizedString, make the switch.",
            ups: 312, downs: 9, seed: "string-catalogs",
            comments: [
                (username: "l10n_engineer", text: "The automatic extraction saves so much time. No more forgetting to add strings to the .strings file.", ups: 67, downs: 1),
                (username: "multi_lang_app", text: "How does it handle right-to-left languages? That's always been my pain point.", ups: 23, downs: 0),
                (username: "localization_pro", text: "RTL works great with SwiftUI's built-in layout mirroring. Just test with Arabic or Hebrew in the preview.", ups: 34, downs: 0),
            ]
        ),
        (
            username: "dependency_free",
            title: "Challenge: Build an iOS app with zero third-party dependencies",
            domain: "r/iOSProgramming",
            text: "I challenged myself to build a complete app using only Apple frameworks. URLSession instead of Alamofire, async/await instead of RxSwift, SwiftUI instead of SnapKit, Keychain Services instead of KeychainAccess. It was eye-opening how capable the first-party frameworks have become.",
            ups: 478, downs: 25, seed: "zero-dependencies",
            comments: [
                (username: "minimalist_dev", text: "Been doing this for years. Fewer dependencies = fewer breaking changes on Xcode updates.", ups: 145, downs: 8),
                (username: "library_fan", text: "Some libraries genuinely add value though. Firebase, Sentry, RevenueCat - I wouldn't reinvent those.", ups: 89, downs: 5),
                (username: "dependency_free", text: "Totally fair. I'm not anti-dependency, just pro-understanding what Apple gives you for free.", ups: 112, downs: 2),
            ]
        ),
        (
            username: "review_guidelines",
            title: "App Review rejected my app 4 times - here's what finally worked",
            domain: "r/iOSProgramming",
            text: "My social app kept getting rejected for Guideline 4.3 (spam/duplicate). Turns out the reviewers couldn't tell my app apart from existing ones in screenshots alone. I redesigned the onboarding to immediately show unique value and got approved on the 5th try.",
            ups: 634, downs: 17, seed: "app-review-tips",
            comments: [
                (username: "rejected_again", text: "The appeal process is also worth trying. I got a rejection overturned by explaining my app's unique features clearly.", ups: 78, downs: 3),
                (username: "app_reviewer_ama", text: "Screenshots and the first 30 seconds of the app experience matter the most. Make your value proposition obvious.", ups: 145, downs: 1),
                (username: "review_guidelines", text: "I also added a detailed App Review Notes section explaining the unique features. That helped a lot.", ups: 67, downs: 0),
                (username: "first_time_dev", text: "This terrifies me as someone about to submit my first app. Any preventive tips?", ups: 34, downs: 0),
                (username: "review_guidelines", text: "Read the guidelines thoroughly, have a working demo account ready, and include clear screenshots. You'll be fine!", ups: 89, downs: 0),
            ]
        ),
    ]

    for (index, p) in posts.enumerated() {
        let post = Post(
            username: p.username,
            createdAt: now - Double(index) * 3600,
            title: p.title,
            domain: p.domain,
            text: p.text,
            ups: p.ups,
            downs: p.downs,
            imageURL: "https://picsum.photos/seed/\(p.seed)/800/600"
        )
        try await post.save(on: app.db)

        for c in p.comments {
            let comment = Comment(
                postID: try post.requireID(),
                username: c.username,
                text: c.text,
                ups: c.ups,
                downs: c.downs
            )
            try await comment.save(on: app.db)
        }
    }

    app.logger.info("Seeded \(posts.count) posts with comments.")
}
