import Foundation

final class FilesViewModelMock: FilesViewModel {
    var isRetryLoading: Bool = false
    var screenState: FilesScreenState = .loading
    var branches: [String] = [
        "development",
        "feature/rosta",
        "fix/verca"
    ]
    var selectedBranchName: String = "development"

    public init(screenState: FilesScreenState = .loading) {
        self.screenState = screenState
    }

    func onAppear() {}
    func retry() {}
}
