package com.jetbrains.kmpapp.feature.mergeRequests.data

import com.jetbrains.kmpapp.feature.mergeRequests.domain.MergeRequestsRepository
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequest
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestState
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestsPage

internal class MergeRequestsRepositoryImpl(
    private val mergeRequestsRemoteDataSource: MergeRequestsRemoteDataSource
): MergeRequestsRepository {

    override suspend fun getMergeRequests(state: MergeRequestState, projectId: Int?, pageNumber: Int, userId: String?): MergeRequestsPage {
        return mergeRequestsRemoteDataSource.getMergeRequests(state, projectId, pageNumber, userId)
    }
}
