import Foundation
import shared

@Observable
final class MergeRequestsViewModelMock: MergeRequestsViewModel {
    
    var screenState: [MergeRequestState : MergeRequestsScreenState] = [:]
    var selectedState: MergeRequestState = .opened
    var hasNextPage: [MergeRequestState : Bool] = [:]
    var isLoadingNextPage: [MergeRequestState : Bool] = [:]
    var isRetryLoading: [MergeRequestState : Bool] = [:]

    init(screenState: MergeRequestsScreenState = .loading) {
        MergeRequestState.allCases.forEach {
            self.screenState[$0] = screenState
        }
    }

    func onAppear() {}
    func selectState(state: MergeRequestState) {
        selectedState = state
    }
    func isStateSelected(_ state: MergeRequestState) -> Bool {
        selectedState == state
    }
    func loadNextPage() {}
    func hasCurrentStateNextPage() -> Bool { false }
    func refresh() async {}
    func retry() {}
    func openMergeRequest(_ mergeRequest: MergeRequest) {}
}
