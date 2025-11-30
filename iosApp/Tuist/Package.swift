// swift-tools-version:6.0

@preconcurrency import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
    baseSettings: .settings(
        configurations: [.current]
    )
)
#endif

let package = Package(
    name: "Gitlabourer",
    dependencies: [
        .package(
            url: "https://github.com/AckeeCZ/ackee-ios-snapshots",
            revision: "28a367e"
        ),
        .package(
            url: "https://github.com/AckeeCZ/ACKategories",
            .upToNextMajor(from: "6.15.0")
        ),
    ]
)

