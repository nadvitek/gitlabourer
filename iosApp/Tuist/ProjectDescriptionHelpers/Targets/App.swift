import Foundation
import ProjectDescription
import AckeeTemplate

private let targetName = "GitLabourer"
private let bundleID = AppSetup.current.bundleID
private let appName: String = {
    if Environment.current == .production, Configuration.current == .release {
        return "GitLabourer"
    }

    return [targetName, AppSetup.current.appNameValue].joined(separator: " ")
}()

private let codeSigning = CodeSigning.current(
    bundleID: bundleID,
    teamID: AppSetup.current.teamID
)

let app = Target.target(
    name: targetName,
    destinations: Destinations(arrayLiteral: .iPhone, .iPad, .macCatalyst),
    product: .app,
    bundleId: "cz.nadvitek.gitlabourer",
    infoPlist: .extendingDefault(with: [
        "UILaunchScreen": [],
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                        "UISceneClassName": "UIWindowScene"
                    ]
                ]
            ]
        ]
    ]),
    sources: ["GitLabourer/Sources/**"],
    resources: ["GitLabourer/Resources/**"],
    dependencies: [
        .kmp,
        .core,
        .gitlabourerUI,
        .search,
        .projects,
        .login,
        .repository,
        .settings,
        .pipelines,
        .mergeRequests,
        .projectDetail,
        .jobs,
        .mergeRequestDetail
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
