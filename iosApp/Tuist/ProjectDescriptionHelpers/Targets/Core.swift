import Foundation
import ProjectDescription

private let targetName = "Core"
private let basePath = "Modules/" + targetName
private let bundleId = "cz.ackee.\(targetName)"

let core = Target.target(
    name: targetName,
    destinations: .iOS,
    product: .framework,
    bundleId: bundleId,
    infoPlist: .default,
    sources: .sourceFilesList(globs: [
        "\(basePath)/Sources/**",
        .testing(at: basePath)
    ].compactMap { $0 }),
    dependencies: [
        .kmp,
        .ackategories
    ]
)

let coreTesting = Target.target(
    name: "\(targetName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: bundleId,
    infoPlist: .default,
    sources: ["\(basePath)/Tests/**"],
    dependencies: [
        .xctest,
        .target(core)
    ]
)

public extension TargetDependency {
    static let core = TargetDependency.target(ProjectDescriptionHelpers.core)
}
