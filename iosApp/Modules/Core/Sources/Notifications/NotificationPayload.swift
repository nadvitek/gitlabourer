import Foundation

public struct NotificationPayload: Codable {
    public struct MR: Codable {
        public let projectId: Int
        public let iid: Int
        public let title: String
    }
    public struct Pipeline: Codable {
        public let id: Int
        public let status: String
    }

    public let mr: MR
    public let pipeline: Pipeline
}

