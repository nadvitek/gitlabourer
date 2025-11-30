package com.jetbrains.kmpapp.feature.mergeRequests.data

import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequest
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestState
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestsPage

internal interface MergeRequestsRemoteDataSource {
    suspend fun getMergeRequests(state: MergeRequestState, projectId: Int?, pageNumber: Int, userId: String?): MergeRequestsPage

    companion object Endpoints {
        const val MRS = "merge_requests"
        const val PROJECTS = "projects"
        const val PIPELINES = "pipelines"
        const val APPROVALS = "approvals"

        fun mergeRequestWithState(state: MergeRequestState): String {
            return "$MRS?with_labels_details=true&state=${state.value}"
        }

        fun mergeRequestWithStateForProject(state: MergeRequestState, projectId: Int): String {
            return "$PROJECTS/$projectId/$MRS?with_labels_details=true&state=${state.value}"
        }

        fun mergeRequestWithStateForAssignee(
            state: MergeRequestState,
            assigneeId: String
        ): String {
            return "$MRS?with_labels_details=true&scope=all&assignee_id=${assigneeId}&state=${state.value}"
        }

        fun mergeRequestWithStateForReviewer(
            state: MergeRequestState,
            reviewerId: String
        ): String {
            return "$MRS?with_labels_details=true&scope=all&reviewer_id=${reviewerId}&state=${state.value}"
        }

        fun pipelineForMergeRequest(projectId: String, mrId: String): String {
            return "$PROJECTS/$projectId/$MRS/$mrId/$PIPELINES"
        }

        fun approvalsForMergeRequest(projectId: String, mrId: String): String {
            return "$PROJECTS/$projectId/$MRS/$mrId/$APPROVALS"
        }
    }
}
