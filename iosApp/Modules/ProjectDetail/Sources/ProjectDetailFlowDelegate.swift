import Foundation
import shared

public protocol ProjectDetailFlowDelegate: AnyObject {
    func handleProjectDetailPath(_ path: ProjectDetailPath, project: Project)
}
