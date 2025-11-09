import Foundation
import shared

final class JobsDetailViewModelMock: JobsDetailViewModel {
    var screenState: JobsDetailScreenState
    var job: DetailedJob

    init(
        screenState: JobsDetailScreenState = .loading,
        job: DetailedJob = .mock()
    ) {
        self.screenState = screenState
        self.job = job
    }

    func onAppear() {}
    func openLink(_ webUrl: String) {}
}
