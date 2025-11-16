// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "service",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.119.2"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        // 🔐 JWTKit provides JWT + Vapor integration (Application.jwt.signers).
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.13.0"),
    ],
    targets: [
        .executableTarget(
            name: "service",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "serviceTests",
            dependencies: [
                .target(name: "service"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
