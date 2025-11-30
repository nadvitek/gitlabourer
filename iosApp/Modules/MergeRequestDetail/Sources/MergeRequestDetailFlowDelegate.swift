import Foundation
import shared

public protocol MergeRequestDetailFlowDelegate: AnyObject {
    func onPipelineClick(_ pipeline: Pipeline)
}
