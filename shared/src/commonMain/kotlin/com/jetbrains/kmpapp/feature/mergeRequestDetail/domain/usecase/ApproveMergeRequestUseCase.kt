package com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.usecase

import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.MergeRequestDetailRepository
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestApprovalState
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestDetail
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface ChangeMergeRequestApprovalUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(
        projectId: Long,
        mergeRequestIid: Long,
        state: MergeRequestApprovalState
    ): MergeRequestDetail
}

internal class ChangeMergeRequestApprovalUseCaseImpl(
    private val repository: MergeRequestDetailRepository
): ChangeMergeRequestApprovalUseCase {
    override suspend operator fun invoke(
        projectId: Long,
        mergeRequestIid: Long,
        state: MergeRequestApprovalState
    ): MergeRequestDetail =
        repository.changeMergeRequestApproval(projectId, mergeRequestIid, state)
}
