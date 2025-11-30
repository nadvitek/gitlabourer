package com.jetbrains.kmpapp.feature.mergeRequestDetail.domain

import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestApprovalState
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestDetail

internal interface MergeRequestDetailRepository {

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
}
