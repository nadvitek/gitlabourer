import Foundation
import ProjectDescription

private let targetName = "Login"
private let basePath = "Modules/" + targetName
private let bundleId = "cz.ackee.\(targetName)"

let login = Target.target(
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

let loginTesting = Target.target(
    name: "\(targetName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: bundleId,
    infoPlist: .default,
    sources: ["\(basePath)/Tests/**"],
    dependencies: [
        .xctest,
        .target(login),
        .appTesting
    ]
)

public extension TargetDependency {
    static let login = TargetDependency.target(ProjectDescriptionHelpers.login)
}
