import ActivityKit
import Foundation

public struct MRPipelineActivityAttributes: ActivityAttributes {

    public struct ContentState: Codable, Hashable {
        public let pipelineId: Int
        public let pipelineStatus: String
        public let mrTitle: String
        public let projectId: Int
        public let mrIID: Int

        public init(
            pipelineId: Int,
            pipelineStatus: String,
            mrTitle: String,
            projectId: Int,
            mrIID: Int
        ) {
            self.pipelineId = pipelineId
            self.pipelineStatus = pipelineStatus
            self.mrTitle = mrTitle
            self.projectId = projectId
            self.mrIID = mrIID
        }
    }

    public let projectId: Int
    public let mrIID: Int
    public let mrTitle: String

    public init(projectId: Int, mrIID: Int, mrTitle: String) {
        self.projectId = projectId
        self.mrIID = mrIID
        self.mrTitle = mrTitle
    }
}
