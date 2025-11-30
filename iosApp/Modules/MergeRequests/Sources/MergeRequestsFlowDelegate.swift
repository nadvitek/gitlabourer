import Foundation
import shared

public protocol MergeRequestsFlowDelegate: AnyObject {
    func openMergeRequestDetail(
        projectId: Int64,
        mergeRequestId: Int64
    )
}
