import Foundation
import shared

public protocol JobsFlowDelegate: AnyObject {
    func openJob(_ job: DetailedJob)
}
