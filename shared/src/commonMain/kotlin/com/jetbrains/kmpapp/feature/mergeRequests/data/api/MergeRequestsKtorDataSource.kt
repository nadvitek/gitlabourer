package com.jetbrains.kmpapp.feature.mergeRequests.data.api

import com.jetbrains.kmpapp.core.mapper.ApiPagedResponseMapper
import com.jetbrains.kmpapp.core.model.domain.PageInfo
import com.jetbrains.kmpapp.core.network.GitlabApiClient
import com.jetbrains.kmpapp.feature.mergeRequests.data.MergeRequestsRemoteDataSource
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.mapper.ApiPipelineMapper
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiApprovals
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiLabel
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiMergeRequest
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiPipeline
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequest
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestState
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestsPage
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.Pipeline
import com.jetbrains.kmpapp.feature.mergerequest.data.api.mapper.ApiMergeRequestMapper
import com.jetbrains.kmpapp.feature.project.domain.model.ProjectsPage
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlin.coroutines.cancellation.CancellationException

internal class MergeRequestsKtorDataSource(
    private val apiClient: GitlabApiClient
): MergeRequestsRemoteDataSource {

    private val apiMergeRequestMapper = ApiMergeRequestMapper()
    private val apiPipelineMapper = ApiPipelineMapper()
    private val apiPagedResponseMapper = ApiPagedResponseMapper()

    override suspend fun getMergeRequests(
        state: MergeRequestState,
        projectId: Int?,
        pageNumber: Int,
        userId: String?
    ): MergeRequestsPage = coroutineScope {
        if (projectId != null) {
            val paged = try {
                apiClient.getPaged<List<ApiMergeRequest>>(
                    endpoint = MergeRequestsRemoteDataSource.mergeRequestWithStateForProject(state, projectId)
                )
            } catch (e: Exception) {
                if (e is CancellationException) throw e
                e.printStackTrace()
                return@coroutineScope MergeRequestsPage(
                    items = emptyList(),
                    pageInfo = PageInfo(
                        currentPage = pageNumber,
                        nextPage = null,
                        totalPages = null,
                        totalItems = null,
                        perPage = null
                    )
                )
            }

            val mappedItems = paged.response.map { api ->
                async {
                    val pipeline = runCatching {
                        getPipeline(
                            projectId = api.projectId.toString(),
                            mrId = api.iid.toString()
                        )
                    }.getOrNull()

                    val approval: Result<Boolean> = runCatching {
                        getApproval(
                            projectId = api.projectId.toString(),
                            mrId = api.iid.toString()
                        )
                    }

                    val mapped = apiMergeRequestMapper.map(api)
                    mapped.copy(pipeline = pipeline, isApproved = approval.getOrDefault(false))
                }
            }.awaitAll()

            val pageInfo = apiPagedResponseMapper.map(paged)

            return@coroutineScope MergeRequestsPage(
                items = mappedItems,
                pageInfo = pageInfo
            )
        } else if (userId != null) {
            val result = try {
                val assigneeDeferred = async {
                    apiClient.getPaged<List<ApiMergeRequest>>(
                        endpoint = MergeRequestsRemoteDataSource.mergeRequestWithStateForAssignee(
                            state = state,
                            assigneeId = userId
                        )
                    )
                }

                val reviewerDeferred = async {
                    apiClient.getPaged<List<ApiMergeRequest>>(
                        endpoint = MergeRequestsRemoteDataSource.mergeRequestWithStateForReviewer(
                            state = state,
                            reviewerId = userId
                        )
                    )
                }

                val assigneePaged = assigneeDeferred.await()
                val reviewerPaged = reviewerDeferred.await()

                assigneePaged to reviewerPaged
            } catch (e: Exception) {
                if (e is CancellationException) throw e
                e.printStackTrace()
                return@coroutineScope MergeRequestsPage(
                    items = emptyList(),
                    pageInfo = PageInfo(
                        currentPage = pageNumber,
                        nextPage = null,
                        totalPages = null,
                        totalItems = null,
                        perPage = null
                    )
                )
            }

            val (assigneePaged, reviewerPaged) = result

            val combinedApiMergeRequests = (assigneePaged.response + reviewerPaged.response)
                .distinctBy { it.projectId to it.iid }
                .sortedByDescending { it.createdAt }

            val mappedItems = combinedApiMergeRequests.map { api ->
                async {
                    val pipeline = runCatching {
                        getPipeline(
                            projectId = api.projectId.toString(),
                            mrId = api.iid.toString()
                        )
                    }.getOrNull()

                    val approval: Result<Boolean> = runCatching {
                        getApproval(
                            projectId = api.projectId.toString(),
                            mrId = api.iid.toString()
                        )
                    }

                    val mapped = apiMergeRequestMapper.map(api)
                    mapped.copy(pipeline = pipeline, isApproved = approval.getOrDefault(false))
                }
            }.awaitAll()

            val pageInfo = when {
                assigneePaged.response.isNotEmpty() -> apiPagedResponseMapper.map(assigneePaged)
                else -> apiPagedResponseMapper.map(reviewerPaged)
            }

            MergeRequestsPage(
                items = mappedItems,
                pageInfo = pageInfo
            )
        } else {
            MergeRequestsPage(
                items = emptyList(),
                pageInfo = PageInfo(
                    currentPage = pageNumber,
                    nextPage = null,
                    totalPages = null,
                    totalItems = null,
                    perPage = null
                )
            )
        }
    }


    suspend fun getPipeline(projectId: String, mrId: String): Pipeline? {
        val response: List<ApiPipeline> = apiClient.get(
            endpoint = MergeRequestsRemoteDataSource.pipelineForMergeRequest(projectId, mrId)
        )
        val first = response.firstOrNull() ?: return null
        return apiPipelineMapper.map(first)
    }

    suspend fun getApproval(projectId: String, mrId: String): Boolean {
        val response: ApiApprovals = apiClient.get(
            endpoint = MergeRequestsRemoteDataSource.approvalsForMergeRequest(projectId, mrId)
        )
        return response.approved
    }
}
