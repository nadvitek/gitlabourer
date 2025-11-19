import Foundation
import Vapor

struct Pipeline: Content {
    let id: Int
    let status: PipelineStatus
}

enum PipelineStatus: String, Codable, Equatable, Content {
    case created
    case waitingForResource
    case preparing
    case pending
    case running
    case success
    case failed
    case canceled
    case canceling
    case skipped
    case manual
    case scheduled
    case unknown

    var isRunning: Bool {
        switch self {
        case .running, .pending, .scheduled, .preparing, .waitingForResource, .created: return true
        default: return false
        }
    }

    var isFinished: Bool {
        switch self {
        case .created, .waitingForResource, .preparing, .pending, .running, .scheduled:
            false
        case .success, .failed, .canceled, .canceling, .skipped, .manual, .unknown:
            true
        }
    }

    enum CodingKeys: String, CodingKey {
        case created
        case waitingForResource = "waiting_for_resource"
        case preparing
        case pending
        case running
        case success
        case failed
        case canceled
        case canceling
        case skipped
        case manual
        case scheduled
        case unknown
    }
}

