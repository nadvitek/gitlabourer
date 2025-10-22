package com.jetbrains.kmpapp.feature.mergeRequests.domain

import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequest
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestState

internal interface MergeRequestsRepository {
    suspend fun getMergeRequests(state: MergeRequestState, projectId: Int?): List<MergeRequest>
}
