import Foundation
import shared

public protocol ProjectsFlowDelegate: AnyObject {
    func onProjectClick(_ project: Project)
}
