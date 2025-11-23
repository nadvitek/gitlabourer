import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "GitLabourer",
    settings: .settings(
        base: [
            "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
            "MARKETING_VERSION": "0.1.0",
        ]
    ),
    targets: projectTargets
)
