import Foundation
import shared

public extension JobsStream {
    var pipelineName: String? {
        sections.flatMap(\.jobs).compactMap(\.pipelineName).first
    }

    func hasTwoOrMoreDownstreams() -> Bool {
        recursiveSearchForTwoOrMoreDownstreams(downstreams)
    }

    private func recursiveSearchForTwoOrMoreDownstreams(_ currentStream: [JobsStream]) -> Bool {
        currentStream.map(\.downstreams).count > 1 || currentStream.map { str in
            recursiveSearchForTwoOrMoreDownstreams(str.downstreams)
        }.contains(true)
    }
}
