import Foundation
import shared

final class PipelinesViewModelMock: PipelinesViewModel {
    var hasNextPage: Bool = false
    var isRetryLoading: Bool = false
    var isLoadingNextPage: Bool = false
    var screenState: PipelinesScreenState

    init(screenState: PipelinesScreenState = .loading) {
        self.screenState = screenState
    }

    func onAppear() {}
    func openLink(_ webUrl: String) {}
    func onPipelineClick(_ pipeline: DetailedPipeline) {}
    func refresh() async {}
    func retry() {}
    func loadNextPage() {}
}

#if DEBUG

extension DetailedPipeline {
    static func mock() -> DetailedPipeline {
        DetailedPipeline(
            id: 0,
            iid: 9,
            name: "🚑Hotfix background fetcha adsdas asd asd asdasda asdasd asdas dasda sdasasd ",
            projectId: 10,
            status: .failed,
            ref: "",
            sha: "",
            webUrl: "",
            user: .mock(),
            createdAt: nil,
            updatedAt: nil,
            startedAt: nil,
            finishedAt: nil,
            durationSeconds: 10,
            queuedDurationSeconds: 10,
            coverage: nil,
            source: nil
        )
    }
}

#endif
