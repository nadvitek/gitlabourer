package com.jetbrains.kmpapp.feature.mergeRequests.domain.usecase

import com.jetbrains.kmpapp.feature.mergeRequests.domain.MergeRequestsRepository
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequest
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestState

import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface GetMergeRequestsUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(state: MergeRequestState, projectId: Int?): List<MergeRequest>
}

internal class GetMergeRequestsUseCaseImpl(
    private val mergeRequestsRepository: MergeRequestsRepository,
) : GetMergeRequestsUseCase {

    override suspend fun invoke(state: MergeRequestState, projectId: Int?): List<MergeRequest> {
        return mergeRequestsRepository.getMergeRequests(state, projectId)
    }
}
