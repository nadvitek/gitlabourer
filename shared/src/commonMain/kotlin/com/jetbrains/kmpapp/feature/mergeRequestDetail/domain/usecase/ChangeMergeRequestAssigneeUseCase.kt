package com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.usecase

import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.MergeRequestDetailRepository
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestDetail
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface ChangeMergeRequestAssigneeUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(
        projectId: Long,
        mergeRequestIid: Long,
        assigneeUserId: Long?
    ): MergeRequestDetail
}

internal class ChangeMergeRequestAssigneeUseCaseImpl(
    private val repository: MergeRequestDetailRepository
): ChangeMergeRequestAssigneeUseCase {
    override suspend operator fun invoke(
        projectId: Long,
        mergeRequestIid: Long,
        assigneeUserId: Long?
    ): MergeRequestDetail =
        repository.changeAssignee(projectId, mergeRequestIid, assigneeUserId)
}
