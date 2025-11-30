import Foundation
import shared

public struct MergeRequestDetailViewModelDependencies {
    let getMergeRequestDetailUseCase: GetMergeRequestDetailUseCase
    let changeMergeRequestApprovalUseCase: ChangeMergeRequestApprovalUseCase
    let mergeMergeRequestUseCase: MergeMergeRequestUseCase

    public init(
        getMergeRequestDetailUseCase: GetMergeRequestDetailUseCase,
        changeMergeRequestApprovalUseCase: ChangeMergeRequestApprovalUseCase,
        mergeMergeRequestUseCase: MergeMergeRequestUseCase
    ) {
        self.getMergeRequestDetailUseCase = getMergeRequestDetailUseCase
        self.changeMergeRequestApprovalUseCase = changeMergeRequestApprovalUseCase
        self.mergeMergeRequestUseCase = mergeMergeRequestUseCase
    }
}
