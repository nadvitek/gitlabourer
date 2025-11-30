package com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.usecase

import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.MergeRequestDetailRepository
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestApprovalState
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestDetail
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface MergeMergeRequestUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(
        projectId: Long,
        mergeRequestIid: Long
    ): MergeRequestDetail
}

internal class MergeMergeRequestUseCaseImpl(
    private val repository: MergeRequestDetailRepository
): MergeMergeRequestUseCase {
    override suspend operator fun invoke(
        projectId: Long,
        mergeRequestIid: Long,
    ): MergeRequestDetail =
        repository.mergeMergeRequest(projectId, mergeRequestIid)
}
