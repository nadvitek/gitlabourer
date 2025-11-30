package com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.usecase

import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.MergeRequestDetailRepository
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestDetail
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface ChangeMergeRequestReviewerUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(
        projectId: Long,
        mergeRequestIid: Long,
        reviewerUserId: Long?
    ): MergeRequestDetail
}

internal class ChangeMergeRequestReviewerUseCaseImpl(
    private val repository: MergeRequestDetailRepository
): ChangeMergeRequestReviewerUseCase {
    override suspend operator fun invoke(
        projectId: Long,
        mergeRequestIid: Long,
        reviewerUserId: Long?
    ): MergeRequestDetail =
        repository.changeReviewers(projectId, mergeRequestIid, reviewerUserId)
}
