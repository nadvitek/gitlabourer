import Foundation
import shared

final class JobsDetailViewModelMock: JobsDetailViewModel {
    var screenState: JobsDetailScreenState
    var job: DetailedJob
    var isRetryLoading: Bool = false

    init(
        screenState: JobsDetailScreenState = .loading,
        job: DetailedJob = .mock()
    ) {
        self.screenState = screenState
        self.job = job
    }

    func onAppear() {}
    func openLink(_ webUrl: String) {}
    func retry() {}
}
