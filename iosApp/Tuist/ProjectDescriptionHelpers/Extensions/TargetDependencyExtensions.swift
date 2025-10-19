import Foundation
import ProjectDescription

extension TargetDependency {
    static let ackategories = TargetDependency.external(name: "ACKategories")
    static let kmp = TargetDependency.xcframework(path: "../shared/build/XCFrameworks/debug/shared.xcframework")
}
