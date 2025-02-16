import ProjectDescription

let project = Project(
    name: "GitLabourer",
    targets: [
        .target(
            name: "GitLabourer",
            destinations: .iOS,
            product: .app,
            bundleId: "cz.nadvitek.GitLabourer",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["GitLabourer/Sources/**"],
            resources: ["GitLabourer/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "GitLabourerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "cz.nadvitek.GitLabourer",
            infoPlist: .default,
            sources: ["GitLabourer/Tests/**"],
            resources: [],
            dependencies: [.target(name: "GitLabourer")]
        ),
    ]
)
