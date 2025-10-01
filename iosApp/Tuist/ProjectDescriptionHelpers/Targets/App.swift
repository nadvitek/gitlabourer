import Foundation
import ProjectDescription

let app = Target.target(
    name: "GitLabourer",
    destinations: .iOS,
    product: .app,
    bundleId: "cz.nadvitek.GitLabourer",
    infoPlist: .default,
    sources: ["GitLabourer/Sources/**"],
    resources: ["GitLabourer/Resources/**"],
    dependencies: [
        .kmp,
        .target(gitlabourerUI),
        .target(projects)
    ]
)

let appTesting = Target.target(
    name: "GitLabourerTests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "cz.nadvitek.GitLabourer",
    infoPlist: .default,
    sources: ["GitLabourer/Tests/**"],
    resources: [],
    dependencies: [
        .xctest,
        .target(app)
    ]
)
