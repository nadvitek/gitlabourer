package com.jetbrains.kmpapp.feature.mergeRequestDetail.data

import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.MergeRequestDetailRepository
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestApprovalState
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestDetail

internal class MergeRequestDetailRepositoryImpl(
    private val mergeRequestDetailRemoteDataSource: MergeRequestDetailRemoteDataSource,
) : MergeRequestDetailRepository {

    override suspend fun getMergeRequestDetail(
        projectId: Long,
        mergeRequestIid: Long
    ): MergeRequestDetail {
        return mergeRequestDetailRemoteDataSource.getMergeRequestDetail(projectId, mergeRequestIid)
    }

    override suspend fun changeAssignee(
        projectId: Long,
        mergeRequestIid: Long,
        assigneeUserId: Long?
    ): MergeRequestDetail {
        return mergeRequestDetailRemoteDataSource.changeAssignee(projectId, mergeRequestIid, assigneeUserId)
    }

    override suspend fun changeReviewers(
        projectId: Long,
        mergeRequestIid: Long,
        reviewerUserId: Long?
    ): MergeRequestDetail {
        return mergeRequestDetailRemoteDataSource.changeReviewers(projectId, mergeRequestIid, reviewerUserId)
    }

    override suspend fun changeMergeRequestApproval(
        projectId: Long,
        mergeRequestIid: Long,
        state: MergeRequestApprovalState
    ): MergeRequestDetail {
        return mergeRequestDetailRemoteDataSource.changeMergeRequestApproval(projectId, mergeRequestIid, state)
    }

    override suspend fun mergeMergeRequest(
        projectId: Long,
        mergeRequestIid: Long
    ): MergeRequestDetail {
        return mergeRequestDetailRemoteDataSource.mergeMergeRequest(projectId, mergeRequestIid)
    }
}
