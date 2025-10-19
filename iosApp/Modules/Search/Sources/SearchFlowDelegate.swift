import Foundation
import shared

public protocol SearchFlowDelegate: AnyObject {
    func onProjectClick(_ project: Project)
}
