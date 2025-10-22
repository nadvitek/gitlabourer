import Foundation
import shared

@Observable
final class MergeRequestsViewModelMock: MergeRequestsViewModel {
    var screenState: [MergeRequestState : MergeRequestsScreenState] = [:]
    var selectedState: MergeRequestState = .opened

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
}
