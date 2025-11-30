package com.jetbrains.kmpapp.feature.mergeRequestDetail.data.api

import com.jetbrains.kmpapp.core.model.domain.PageInfo
import com.jetbrains.kmpapp.core.network.GitlabApiClient
import com.jetbrains.kmpapp.feature.jobs.domain.model.JobsPage
import com.jetbrains.kmpapp.feature.mergeRequestDetail.data.MergeRequestDetailRemoteDataSource
import com.jetbrains.kmpapp.feature.mergeRequestDetail.data.MergeRequestDetailRemoteDataSource.Companion.mergeRequestDetail
import com.jetbrains.kmpapp.feature.mergeRequestDetail.data.api.mapper.ApiMergeRequestDetailMapper
import com.jetbrains.kmpapp.feature.mergeRequestDetail.data.api.model.ApiMergeRequestDetail
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestApprovalState
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestDetail
import com.jetbrains.kmpapp.feature.mergeRequests.data.MergeRequestsRemoteDataSource
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiApprovals
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiLabel
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MRState
import com.jetbrains.kmpapp.feature.mergerequest.data.api.mapper.ApiMergeRequestMapper
import kotlin.coroutines.cancellation.CancellationException

internal class MergeRequestDetailKtorDataSource(
    private val apiClient: GitlabApiClient
) : MergeRequestDetailRemoteDataSource {

    private val apiMergeRequestMapper = ApiMergeRequestMapper()
    private val apiMergeRequestDetailMapper = ApiMergeRequestDetailMapper()

    override suspend fun getMergeRequestDetail(
        projectId: Long,
        mergeRequestIid: Long
    ): MergeRequestDetail {
        val detail = try {
            apiClient.get<ApiMergeRequestDetail>(
                endpoint = mergeRequestDetail(projectId, mergeRequestIid)
            )
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()

            return MergeRequestDetail(
                id = 0,
                iid = 0,
                projectId = 0,
                title = "",
                description = "",
                labels = emptyList(),
                assignee = null,
                reviewers = emptyList(),
                webUrl = "",
                sourceBranch = "",
                targetBranch = "",
                changesCount = null,
                pipeline = null,
                state = MRState.MERGED,
                approved = false,
                canMerge = false
            )
        }

        val mappedDetail = apiMergeRequestDetailMapper.map(detail)

        val allLabels = apiClient.get<List<ApiLabel>>(
            endpoint = MergeRequestDetailRemoteDataSource.labels(projectId)
        )

        val approval: Result<Boolean> = runCatching {
            getApproval(
                projectId = projectId.toString(),
                mrId = mergeRequestIid.toString()
            )
        }

        val filteredLabels = allLabels.filter { apiLabel ->
            detail.labels.contains(apiLabel.name)
        }.map(apiMergeRequestMapper::map)

        mappedDetail.labels = filteredLabels
        mappedDetail.approved = approval.getOrNull() ?: false

        return mappedDetail
    }

    override suspend fun changeAssignee(
        projectId: Long,
        mergeRequestIid: Long,
        assigneeUserId: Long?
    ): MergeRequestDetail {
        TODO("Not yet implemented")
    }

    override suspend fun changeReviewers(
        projectId: Long,
        mergeRequestIid: Long,
        reviewerUserId: Long?
    ): MergeRequestDetail {
        TODO("Not yet implemented")
    }

    override suspend fun changeMergeRequestApproval(
        projectId: Long,
        mergeRequestIid: Long,
        state: MergeRequestApprovalState
    ): MergeRequestDetail {
        return when (state) {
            MergeRequestApprovalState.APPROVED -> approveMergeRequest(projectId, mergeRequestIid)
            MergeRequestApprovalState.UNAPPROVED -> unapproveMergeRequest(projectId, mergeRequestIid)
        }
    }

    override suspend fun mergeMergeRequest(
        projectId: Long,
        mergeRequestIid: Long
    ): MergeRequestDetail {
        val detail = try {
            apiClient.put<ApiMergeRequestDetail>(
                endpoint = mergeRequestDetail(projectId, mergeRequestIid)
            )
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()

            return MergeRequestDetail(
                id = 0,
                iid = 0,
                projectId = 0,
                title = "",
                description = "",
                labels = emptyList(),
                assignee = null,
                reviewers = emptyList(),
                webUrl = "",
                sourceBranch = "",
                targetBranch = "",
                changesCount = null,
                pipeline = null,
                state = MRState.MERGED,
                approved = false,
                canMerge = false
            )
        }

        val mappedDetail = apiMergeRequestDetailMapper.map(detail)

        val allLabels = apiClient.get<List<ApiLabel>>(
            endpoint = MergeRequestDetailRemoteDataSource.labels(projectId)
        )

        val approval: Result<Boolean> = runCatching {
            getApproval(
                projectId = projectId.toString(),
                mrId = mergeRequestIid.toString()
            )
        }

        val filteredLabels = allLabels.filter { apiLabel ->
            detail.labels.contains(apiLabel.name)
        }.map(apiMergeRequestMapper::map)

        mappedDetail.labels = filteredLabels
        mappedDetail.approved = approval.getOrNull() ?: false

        return mappedDetail
    }

    private suspend fun approveMergeRequest(
        projectId: Long,
        mergeRequestIid: Long
    ): MergeRequestDetail {
        val detail = try {
            apiClient.post<ApiApprovals>(
                endpoint = MergeRequestDetailRemoteDataSource.approveMergeRequest(projectId, mergeRequestIid)
            )

            apiClient.get<ApiMergeRequestDetail>(
                endpoint = mergeRequestDetail(projectId, mergeRequestIid)
            )
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()

            return MergeRequestDetail(
                id = 0,
                iid = 0,
                projectId = 0,
                title = "",
                description = "",
                labels = emptyList(),
                assignee = null,
                reviewers = emptyList(),
                webUrl = "",
                sourceBranch = "",
                targetBranch = "",
                changesCount = null,
                pipeline = null,
                state = MRState.MERGED,
                approved = false,
                canMerge = false
            )
        }

        val mappedDetail = apiMergeRequestDetailMapper.map(detail)

        val allLabels = apiClient.get<List<ApiLabel>>(
            endpoint = MergeRequestDetailRemoteDataSource.labels(projectId)
        )

        val approval: Result<Boolean> = runCatching {
            getApproval(
                projectId = projectId.toString(),
                mrId = mergeRequestIid.toString()
            )
        }

        val filteredLabels = allLabels.filter { apiLabel ->
            detail.labels.contains(apiLabel.name)
        }.map(apiMergeRequestMapper::map)

        mappedDetail.labels = filteredLabels
        mappedDetail.approved = approval.getOrNull() ?: false

        return mappedDetail
    }

    private suspend fun unapproveMergeRequest(
        projectId: Long,
        mergeRequestIid: Long
    ): MergeRequestDetail {
        val detail = try {
            apiClient.post<ApiApprovals>(
                endpoint = MergeRequestDetailRemoteDataSource.unapproveMergeRequest(projectId, mergeRequestIid)
            )

            apiClient.get<ApiMergeRequestDetail>(
                endpoint = mergeRequestDetail(projectId, mergeRequestIid)
            )
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()

            return MergeRequestDetail(
                id = 0,
                iid = 0,
                projectId = 0,
                title = "",
                description = "",
                labels = emptyList(),
                assignee = null,
                reviewers = emptyList(),
                webUrl = "",
                sourceBranch = "",
                targetBranch = "",
                changesCount = null,
                pipeline = null,
                state = MRState.MERGED,
                approved = false,
                canMerge = false
            )
        }

        val mappedDetail = apiMergeRequestDetailMapper.map(detail)

        val allLabels = apiClient.get<List<ApiLabel>>(
            endpoint = MergeRequestDetailRemoteDataSource.labels(projectId)
        )

        val approval: Result<Boolean> = runCatching {
            getApproval(
                projectId = projectId.toString(),
                mrId = mergeRequestIid.toString()
            )
        }

        val filteredLabels = allLabels.filter { apiLabel ->
            detail.labels.contains(apiLabel.name)
        }.map(apiMergeRequestMapper::map)

        mappedDetail.labels = filteredLabels
        mappedDetail.approved = approval.getOrNull() ?: false

        return mappedDetail
    }

    suspend fun getApproval(projectId: String, mrId: String): Boolean {
        val response: ApiApprovals = apiClient.get(
            endpoint = MergeRequestsRemoteDataSource.approvalsForMergeRequest(projectId, mrId)
        )
        return response.approved
    }
}
