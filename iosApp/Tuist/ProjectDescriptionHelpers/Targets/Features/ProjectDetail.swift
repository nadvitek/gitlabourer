import Foundation
import ProjectDescription

private let targetName = "ProjectDetail"
private let basePath = "Modules/" + targetName
private let bundleId = "cz.nadvitek.\(targetName)"

let projectDetail = Target.target(
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
        .kmp
    ]
)

let projectDetailTesting = Target.target(
    name: "\(targetName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: bundleId,
    infoPlist: .default,
    sources: ["\(basePath)/Tests/**"],
    dependencies: [
        .xctest,
        .target(projectDetail)
    ]
)

public extension TargetDependency {
    static let projectDetail = TargetDependency.target(ProjectDescriptionHelpers.projectDetail)
}
