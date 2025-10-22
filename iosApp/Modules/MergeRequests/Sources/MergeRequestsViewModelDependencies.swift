import Foundation
import shared

public struct MergeRequestsViewModelDependencies {
    public let getMergeRequestsUseCase: GetMergeRequestsUseCase

    public init(
        getMergeRequestsUseCase: GetMergeRequestsUseCase
    ) {
        self.getMergeRequestsUseCase = getMergeRequestsUseCase
    }
}
