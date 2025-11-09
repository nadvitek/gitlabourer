import Foundation
import shared

public struct JobsDetailViewModelDependencies {
    let cancelJobUseCase: CancelJobUseCase
    let retryJobUseCase: RetryJobUseCase
    let getJobLogUseCase: GetJobLogUseCase

    public init(
        cancelJobUseCase: CancelJobUseCase,
        retryJobUseCase: RetryJobUseCase,
        getJobLogUseCase: GetJobLogUseCase
    ) {
        self.cancelJobUseCase = cancelJobUseCase
        self.retryJobUseCase = retryJobUseCase
        self.getJobLogUseCase = getJobLogUseCase
    }
}
