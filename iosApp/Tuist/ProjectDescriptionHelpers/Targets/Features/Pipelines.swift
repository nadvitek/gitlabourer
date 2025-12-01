import Foundation
import ProjectDescription

private let targetName = "Pipelines"
private let basePath = "Modules/" + targetName
private let bundleId = "cz.nadvitek.\(targetName)"

let pipelines = Target.target(
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
        .core,
        .kmp
    ]
)

let pipelinesTesting = Target.target(
    name: "\(targetName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: bundleId,
    infoPlist: .default,
    sources: ["\(basePath)/Tests/**"],
    dependencies: [
        .xctest,
        .target(pipelines),
        .appTesting
    ]
)

public extension TargetDependency {
    static let pipelines = TargetDependency.target(ProjectDescriptionHelpers.pipelines)
}
