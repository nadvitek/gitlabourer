// swift-tools-version:6.0

@preconcurrency import PackageDescription

#if TUIST
@preconcurrency import ProjectDescription

let packageSettings = PackageSettings(
    baseSettings: .settings(
        configurations: [.debug(
            name: .debug
        )]
    )
)
#endif

let playerVersion: PackageDescription.Version = "8.11.0"

let package = Package(
    name: "Gitlabourer",
    dependencies: [
        .package(
            url: "https://github.com/AckeeCZ/ackee-ios-snapshots",
            revision: "28f9aba"
        ),
        .package(
            url: "https://github.com/AckeeCZ/ACKategories",
            .upToNextMajor(from: "6.15.0")
        ),
    ]
)

