package com.jetbrains.kmpapp.feature.pipelines.data.api

import com.jetbrains.kmpapp.core.model.api.ApiCommit
import com.jetbrains.kmpapp.core.network.GitlabApiClient
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiPipeline
import com.jetbrains.kmpapp.feature.pipelines.data.PipelinesRemoteDataSource
import com.jetbrains.kmpapp.feature.pipelines.data.api.mapper.ApiDetailedPipelineMapper
import com.jetbrains.kmpapp.feature.pipelines.data.api.model.ApiDetailedPipeline
import com.jetbrains.kmpapp.feature.pipelines.domain.model.DetailedPipeline
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlin.collections.emptyList
import kotlin.coroutines.cancellation.CancellationException

internal class PipelinesKtorDataSource(
    private val apiClient: GitlabApiClient
): PipelinesRemoteDataSource {

    private val apiDetailedPipelineMapper = ApiDetailedPipelineMapper()

    override suspend fun getPipelines(projectId: Int, pageNumber: Int): List<DetailedPipeline> = coroutineScope {
        val response = try {
            apiClient.get<List<ApiPipeline>>(
                endpoint = PipelinesRemoteDataSource.projectPipelines(projectId, pageNumber)
            )
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()
            emptyList()
        }

        response.map { api ->
            async {
                runCatching {
                    getPipeline(
                        projectId = projectId,
                        pipelineId = api.id.toInt()
                    )
                }.getOrNull()
            }
        }.awaitAll().filterNotNull()
    }

    private suspend fun getPipeline(projectId: Int, pipelineId: Int): DetailedPipeline? {
        val apiDetail: ApiDetailedPipeline = apiClient.get(
            endpoint = PipelinesRemoteDataSource.detailedPipeline(projectId, pipelineId)
        )

        val mapped: DetailedPipeline = apiDetailedPipelineMapper.map(apiDetail)

        val sha = mapped.sha
        val commitTitle: String? = runCatching {
            apiClient.get<ApiCommit>(
                endpoint = PipelinesRemoteDataSource.pipelineName(projectId, sha)
            ).title
        }.getOrNull()

        return if (!commitTitle.isNullOrBlank()) mapped.copy(name = commitTitle) else mapped
    }

}
