import Foundation
import Vapor

struct Result: Content {
    let mergeRequest: MergeRequest
    let pipeline: Pipeline
}
