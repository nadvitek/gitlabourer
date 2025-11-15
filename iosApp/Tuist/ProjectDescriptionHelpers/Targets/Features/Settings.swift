import Foundation
import ProjectDescription

private let targetName = "Settings"
private let basePath = "Modules/" + targetName
private let bundleId = "cz.nadvitek.\(targetName)"

let settings = Target.target(
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
        .gitlabourerUI,
        .kmp,
        .core
    ]
)

let settingsTesting = Target.target(
    name: "\(targetName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: bundleId,
    infoPlist: .default,
    sources: ["\(basePath)/Tests/**"],
    dependencies: [
        .xctest,
        .target(settings)
    ]
)

public extension TargetDependency {
    static let settings = TargetDependency.target(ProjectDescriptionHelpers.settings)
}
