import Foundation
import ProjectDescription

let app = Target.target(
    name: "GitLabourer",
    destinations: .iOS,
    product: .app,
    bundleId: "cz.nadvitek.GitLabourer",
    infoPlist: .extendingDefault(with: [
        "UILaunchScreen": [
        ]
//        "UIApplicationSceneManifest": [
//            "UIApplicationSupportsMultipleScenes": false,
//            "UISceneConfigurations": [
//                "UIWindowSceneSessionRoleApplication": [
//                    [
//                        "UISceneConfigurationName": "Default Configuration",
//                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
//                        "UISceneClassName": "UIWindowScene"
//                    ]
//                ]
//            ]
//        ]
    ]),
    sources: ["GitLabourer/Sources/**"],
    resources: ["GitLabourer/Resources/**"],
    dependencies: [
        .kmp,
        .gitlabourerUI,
        .search,
        .projects,
        .login
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
