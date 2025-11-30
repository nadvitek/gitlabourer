import Foundation
import shared

final class MergeRequestDetailViewModelMock: MergeRequestDetailViewModel {
    var screenState: MergeRequestDetailScreenState
    var isRetryLoading: Bool = false
    var isMergeLoading: Bool = false
    var isApprovalLoading: Bool = false

    init(
        screenState: MergeRequestDetailScreenState = .loading
    ) {
        self.screenState = screenState
    }

    func onAppear() {}
    func refresh() async {}
    func retry() {}
    func toggleApprove() {}
    func merge() {}
    func openUrl(urlString: String?) {}
    func onPipelineClick(pipeline: Pipeline) {}
}
