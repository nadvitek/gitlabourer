package com.jetbrains.kmpapp.feature.mergeRequests.domain.usecase

import com.jetbrains.kmpapp.feature.mergeRequests.domain.MergeRequestsRepository
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequest
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestState
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestsPage
import com.jetbrains.kmpapp.feature.user.data.UserLocalDataSource

import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface GetMergeRequestsUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(state: MergeRequestState, projectId: Int?, pageNumber: Int): MergeRequestsPage
}

internal class GetMergeRequestsUseCaseImpl(
    private val mergeRequestsRepository: MergeRequestsRepository,
    private val userLocalDataSource: UserLocalDataSource,
) : GetMergeRequestsUseCase {

    override suspend fun invoke(state: MergeRequestState, projectId: Int?, pageNumber: Int): MergeRequestsPage {
        val userId = userLocalDataSource.getUserId()?.id
        return mergeRequestsRepository.getMergeRequests(state, projectId, pageNumber, userId)
    }
}
