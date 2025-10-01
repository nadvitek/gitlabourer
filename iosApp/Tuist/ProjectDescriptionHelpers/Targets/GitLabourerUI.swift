import Foundation
import ProjectDescription

private let targetName = "GitLabourerUI"
private let basePath = "Modules/" + targetName
private let bundleId = "cz.nadvitek.\(targetName)"

let gitlabourerUI = Target.target(
    name: targetName,
    destinations: .iOS,
    product: .framework,
    bundleId: bundleId,
    infoPlist: .default,
    sources: ["\(basePath)/Sources/**"],
    resources: ["\(basePath)/Resources/**"],
    dependencies: [
        .kmp
    ]
)

let gitlabourerUITesting = Target.target(
    name: "\(targetName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: bundleId,
    infoPlist: .default,
    sources: ["\(basePath)/Tests/**"],
    dependencies: [
        .xctest,
        .target(gitlabourerUI)
    ]
)
