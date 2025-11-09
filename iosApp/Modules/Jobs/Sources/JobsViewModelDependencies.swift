import Foundation
import shared

public struct JobsViewModelDependencies {
    let getJobsForProjectUseCase: GetJobsForProjectUseCase
    let getJobsForPipelineUseCase: GetJobsForPipelineUseCase
    let cancelJobUseCase: CancelJobUseCase
    let retryJobUseCase: RetryJobUseCase

    public init(
        getJobsForProjectUseCase: GetJobsForProjectUseCase,
        getJobsForPipelineUseCase: GetJobsForPipelineUseCase,
        cancelJobUseCase: CancelJobUseCase,
        retryJobUseCase: RetryJobUseCase
    ) {
        self.getJobsForProjectUseCase = getJobsForProjectUseCase
        self.getJobsForPipelineUseCase = getJobsForPipelineUseCase
        self.cancelJobUseCase = cancelJobUseCase
        self.retryJobUseCase = retryJobUseCase
    }
}
