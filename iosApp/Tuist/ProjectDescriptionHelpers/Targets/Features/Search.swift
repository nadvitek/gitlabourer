import Foundation
import ProjectDescription

private let targetName = "Search"
private let basePath = "Modules/" + targetName
private let bundleId = "cz.nadvitek.\(targetName)"

let search = Target.target(
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
        .projects,
        .gitlabourerUI,
        .kmp
    ]
)

let searchTesting = Target.target(
    name: "\(targetName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: bundleId,
    infoPlist: .default,
    sources: ["\(basePath)/Tests/**"],
    dependencies: [
        .xctest,
        .target(search),
        .appTesting
    ]
)

public extension TargetDependency {
    static let search = TargetDependency.target(ProjectDescriptionHelpers.search)
}
