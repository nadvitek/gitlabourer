package com.jetbrains.kmpapp.feature.mergeRequests.data.api

import com.jetbrains.kmpapp.core.network.GitlabApiClient
import com.jetbrains.kmpapp.feature.mergeRequests.data.MergeRequestsRemoteDataSource
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.mapper.ApiPipelineMapper
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiMergeRequest
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiPipeline
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequest
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestState
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.Pipeline
import com.jetbrains.kmpapp.feature.mergerequest.data.api.mapper.ApiMergeRequestMapper
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlin.coroutines.cancellation.CancellationException

internal class MergeRequestsKtorDataSource(
    private val apiClient: GitlabApiClient
): MergeRequestsRemoteDataSource {

    private val apiMergeRequestMapper = ApiMergeRequestMapper()
    private val apiPipelineMapper = ApiPipelineMapper()

    override suspend fun getMergeRequests(state: MergeRequestState, projectId: Int?): List<MergeRequest> = coroutineScope {
        val apiMRs = try {
            apiClient.get<List<ApiMergeRequest>>(
                endpoint = projectId?.let {
                    MergeRequestsRemoteDataSource.mergeRequestWithStateForProject(state, it)
                } ?: MergeRequestsRemoteDataSource.mergeRequestWithState(state)
            )
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()
            emptyList()
        }

        apiMRs.map { api ->
            async {
                val pipeline = runCatching {
                    getPipeline(
                        projectId = api.projectId.toString(),
                        mrId = api.iid.toString()
                    )
                }.getOrNull()

                val mapped = apiMergeRequestMapper.map(api)
                mapped.copy(pipeline = pipeline)
            }
        }.awaitAll()
    }

    suspend fun getPipeline(projectId: String, mrId: String): Pipeline? {
        val response: List<ApiPipeline> = apiClient.get(
            endpoint = MergeRequestsRemoteDataSource.pipelineForMergeRequest(projectId, mrId)
        )
        val first = response.firstOrNull() ?: return null
        return apiPipelineMapper.map(first)
    }
}
