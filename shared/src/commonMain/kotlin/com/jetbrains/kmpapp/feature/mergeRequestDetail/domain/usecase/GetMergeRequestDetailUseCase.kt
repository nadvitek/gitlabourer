package com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.usecase

import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.MergeRequestDetailRepository
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestDetail
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface GetMergeRequestDetailUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(
        projectId: Long,
        mergeRequestIid: Long
    ): MergeRequestDetail
}

internal class GetMergeRequestDetailUseCaseImpl(
    private val repository: MergeRequestDetailRepository
): GetMergeRequestDetailUseCase {
    override suspend operator fun invoke(
        projectId: Long,
        mergeRequestIid: Long
    ): MergeRequestDetail =
        repository.getMergeRequestDetail(projectId, mergeRequestIid)
}
