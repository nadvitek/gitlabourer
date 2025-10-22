package com.jetbrains.kmpapp.feature.mergeRequests.data

import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequest
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestState

internal interface MergeRequestsRemoteDataSource {
    suspend fun getMergeRequests(state: MergeRequestState, projectId: Int?): List<MergeRequest>

    companion object Endpoints {
        const val MRS = "merge_requests"
        const val PROJECTS = "projects"
        const val PIPELINES = "pipelines"

        fun mergeRequestWithState(state: MergeRequestState): String {
            return "$MRS?with_labels_details=true&state=${state.value}"
        }

        fun mergeRequestWithStateForProject(state: MergeRequestState, projectId: Int): String {
            return "$PROJECTS/$projectId/$MRS?with_labels_details=true&state=${state.value}"
        }

        fun pipelineForMergeRequest(projectId: String, mrId: String): String {
            return "$PROJECTS/$projectId/$MRS/$mrId/$PIPELINES"
        }
    }
}
