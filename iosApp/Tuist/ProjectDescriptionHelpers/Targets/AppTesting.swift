import ProjectDescription
import Foundation

private let name = app.name + "_Testing"
let appTesting = Target.target(
    name: name,
    destinations: .iOS,
    product: .framework,
    bundleId: "cz.ackee.gitLabourer",
    sources: "Modules/\(name)/**",
    dependencies: [
        .xctest,
        .external(name: "AckeeSnapshots"),
    ]
)

public extension TargetDependency {
    static let appTesting = TargetDependency.target(ProjectDescriptionHelpers.appTesting)
}
