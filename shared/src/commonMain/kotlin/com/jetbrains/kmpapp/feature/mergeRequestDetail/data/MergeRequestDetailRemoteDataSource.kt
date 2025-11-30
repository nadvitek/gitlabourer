package com.jetbrains.kmpapp.feature.mergeRequestDetail.data

import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestApprovalState
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestDetail

internal interface MergeRequestDetailRemoteDataSource {

    suspend fun getMergeRequestDetail(
        projectId: Long,
        mergeRequestIid: Long
    ): MergeRequestDetail

    suspend fun changeAssignee(
        projectId: Long,
        mergeRequestIid: Long,
        assigneeUserId: Long?
    ): MergeRequestDetail

    suspend fun changeReviewers(
        projectId: Long,
        mergeRequestIid: Long,
        reviewerUserId: Long?
    ): MergeRequestDetail

    suspend fun changeMergeRequestApproval(
        projectId: Long,
        mergeRequestIid: Long,
        state: MergeRequestApprovalState
    ): MergeRequestDetail

    suspend fun mergeMergeRequest(
        projectId: Long,
        mergeRequestIid: Long
    ): MergeRequestDetail

    companion object {

        fun mergeRequestLabels(
            projectId: Long,
            mergeRequestIid: Long
        ): String =
            "projects/$projectId/merge_requests?iid=$mergeRequestIid&with_labels_details=true"

        fun labels(
            projectId: Long
        ): String =
            "projects/$projectId/labels"

        fun mergeRequestDetail(
            projectId: Long,
            mergeRequestIid: Long
        ): String =
            "projects/$projectId/merge_requests/$mergeRequestIid"

        fun approveMergeRequest(
            projectId: Long,
            mergeRequestIid: Long
        ): String =
            "projects/$projectId/merge_requests/$mergeRequestIid/approve"

        fun unapproveMergeRequest(
            projectId: Long,
            mergeRequestIid: Long
        ): String =
            "projects/$projectId/merge_requests/$mergeRequestIid/unapprove"

        fun mergeMergeRequest(
            projectId: Long,
            mergeRequestIid: Long
        ): String =
            "projects/$projectId/merge_requests/$mergeRequestIid/merge"
    }
}
