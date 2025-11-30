package com.jetbrains.kmpapp.feature.mergeRequests.domain

import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequest
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestState
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestsPage

internal interface MergeRequestsRepository {
    suspend fun getMergeRequests(state: MergeRequestState, projectId: Int?, pageNumber: Int, userId: String?): MergeRequestsPage
}
