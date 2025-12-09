import Foundation
import Vapor

struct Result: Content {
    let projectName: String
    let mergeRequest: MergeRequest
    let pipeline: Pipeline
}
