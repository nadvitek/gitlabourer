import Foundation
import Vapor

struct Pipeline: Content {
    let id: Int
    let status: PipelineStatus
}

enum PipelineStatus: Codable, Equatable {
    case created
    case waitingForResource
    case preparing
    case pending
    case running
    case success
    case failed
    case canceled
    case skipped
    case manual
    case scheduled
    case unknown

    var isRunning: Bool {
        switch self {
        case .running, .pending, .scheduled, .preparing, .waitingForResource: return true
        default: return false
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
        case skipped
        case manual
        case scheduled
        case unknown
    }
}

