import Foundation

struct MRPayload: Decodable {
    let projectId: Int
    let iid: Int
    let title: String
}

struct PipelinePayload: Decodable {
    let id: Int
    let status: String
}

struct NotificationPayload: Decodable {
    let mr: MRPayload
    let pipeline: PipelinePayload
}

