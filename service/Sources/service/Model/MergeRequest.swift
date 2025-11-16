import Foundation
import Vapor

struct MergeRequest: Content {
    let id: Int
    let iid: Int
    let project_id: Int
    let title: String
}
