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
    destinations: [.iPhone, .iPad, .macWithiPadDesign],
    product: .app,
    bundleId: "cz.ackee.gitlabourer",
    infoPlist: .extendingDefault(with: [
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
        ],
        "UILaunchStoryboardName": "LaunchScreen.storyboard",
        "UILaunchScreen": [
            "UIImageName": "LaunchScreen"
        ],
        "UIBackgroundModes": ["fetch", "remote-notification"],
        "NSAppTransportSecurity": [
            "NSAllowsArbitraryLoads": true
        ],
        "NSSupportsLiveActivities": true,
    ]),
    sources: ["GitLabourer/Sources/**"],
    resources: ["GitLabourer/Resources/**"],
    entitlements: "GitLabourer/App.entitlements",
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
        .mergeRequestDetail,
//        .target(appWidgets),
    ],
    settings: .settings(
        base: codeSigning.settings,
        configurations: [.current]
    )
)

//let appWidgets = Target.target(
//    name: "GitLabourerWidgets",
//    destinations: Destinations(arrayLiteral: .iPhone),
//    product: .appExtension,
//    bundleId: "cz.ackee.gitlabourer.widgets",
//    infoPlist: .extendingDefault(with: [
//        "NSExtension": [
//            "NSExtensionPointIdentifier": "com.apple.widgetkit-extension"
//        ]
//    ]),
//    sources: "GitLabourerWidgets/Sources/**",
//    dependencies: [
//        .target(core)
//    ],
//    settings: .settings(
//        base: codeSigning.settings,
//        configurations: [.current]
//    )
//)

//let notificationService = Target.target(
//    name: "GitLabourerNotificationService",
//    destinations: Destinations(arrayLiteral: .iPhone),
//    product: .appExtension,
//    bundleId: "cz.ackee.gitlabourer.notification-service",
//    infoPlist: .extendingDefault(with: [
//        "NSExtension": [
//            "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
//            "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService"
//        ]
//    ]),
//    sources: ["GitLabourerNotificationService/Sources/**"],
//    resources: [],
//    entitlements: nil,
//    dependencies: [
//        .target(core)
//    ],
//    settings: .settings(
//        base: codeSigning.settings,
//        configurations: [.current]
//    )
//)

let appTests = Target.target(
    name: "GitLabourerTests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "cz.ackee.gitLabourer",
    infoPlist: .default,
    sources: ["GitLabourer/Tests/**"],
    resources: [],
    dependencies: [
        .xctest,
        .target(app),
        .appTesting
    ]
)
