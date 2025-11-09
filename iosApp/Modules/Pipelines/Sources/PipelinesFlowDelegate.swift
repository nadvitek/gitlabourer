import Foundation
import shared

public protocol PipelinesFlowDelegate: AnyObject {
    func onPipelineClick(_ pipeline: DetailedPipeline)
}
