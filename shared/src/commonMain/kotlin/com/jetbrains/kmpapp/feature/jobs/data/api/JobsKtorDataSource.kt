package com.jetbrains.kmpapp.feature.jobs.data.api

import com.jetbrains.kmpapp.core.mapper.ApiPagedResponseMapper
import com.jetbrains.kmpapp.core.model.domain.PageInfo
import com.jetbrains.kmpapp.core.network.GitlabApiClient
import com.jetbrains.kmpapp.feature.jobs.data.JobsRemoteDataSource
import com.jetbrains.kmpapp.feature.jobs.data.api.mapper.ApiBridgeMapper
import com.jetbrains.kmpapp.feature.jobs.data.api.mapper.ApiDetailedJobMapper
import com.jetbrains.kmpapp.feature.jobs.data.api.model.ApiBridge
import com.jetbrains.kmpapp.feature.jobs.data.api.model.ApiDetailedJob
import com.jetbrains.kmpapp.feature.jobs.data.api.model.ApiJobSummary
import com.jetbrains.kmpapp.feature.jobs.domain.model.Bridge
import com.jetbrains.kmpapp.feature.jobs.domain.model.DetailedJob
import com.jetbrains.kmpapp.feature.jobs.domain.model.JobLog
import com.jetbrains.kmpapp.feature.jobs.domain.model.JobsPage
import kotlinx.coroutines.coroutineScope
import kotlin.coroutines.cancellation.CancellationException

internal class JobsKtorDataSource(
    private val apiClient: GitlabApiClient
) : JobsRemoteDataSource {

    private val apiDetailedJobMapper = ApiDetailedJobMapper()
    private val apiBridgeMapper = ApiBridgeMapper()
    private val apiPagedResponseMapper = ApiPagedResponseMapper()

    override suspend fun getJobs(projectId: Int, pageNumber: Int): JobsPage {
        val paged = try {
            apiClient.getPaged<List<ApiJobSummary>>(
                endpoint = JobsRemoteDataSource.projectJobs(projectId, pageNumber)
            )
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()
            return JobsPage(
                items = emptyList(),
                PageInfo(
                    currentPage = pageNumber,
                    nextPage = null,
                    totalPages = null,
                    totalItems = null,
                    perPage = null
                )
            )
        }

        val mappedItems = paged.response.map(apiDetailedJobMapper::map)

        val pageInfo = apiPagedResponseMapper.map(paged)

        return JobsPage(
            items = mappedItems,
            pageInfo = pageInfo
        )
    }

    override suspend fun getJobsForPipeline(
        projectId: Int,
        pipelineId: Long
    ): List<DetailedJob>  {
        val summaries = try {
            apiClient.get<List<ApiJobSummary>>(
                endpoint = JobsRemoteDataSource.pipelineJobs(projectId, pipelineId, 0)
            )
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()
            emptyList()
        }

        return summaries.map(apiDetailedJobMapper::map)
    }

    override suspend fun getBridges(projectId: Int, pipelineId: Long, pageNumber: Int): List<Bridge> {
        val bridges = try {
            apiClient.get<List<ApiBridge>>(
                endpoint = JobsRemoteDataSource.pipelineBridges(projectId, pipelineId, pageNumber)
            )
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()
            emptyList()
        }

        return bridges.map(apiBridgeMapper::map)
    }

    override suspend fun retryJob(projectId: Int, jobId: Long): DetailedJob {
        val apiJob: ApiDetailedJob = apiClient.post(
            endpoint = JobsRemoteDataSource.retryJob(projectId, jobId)
        )
        return apiDetailedJobMapper.map(apiJob)
    }

    override suspend fun cancelJob(projectId: Int, jobId: Long): DetailedJob {
        val apiJob: ApiDetailedJob = apiClient.post(
            endpoint = JobsRemoteDataSource.cancelJob(projectId, jobId)
        )
        return apiDetailedJobMapper.map(apiJob)
    }

    override suspend fun getJobLog(projectId: Int, jobId: Long): JobLog {
//        val content: String = try {
//            apiClient.getText(
//                endpoint = JobsRemoteDataSource.jobTrace(projectId, jobId)
//            )
//        } catch (e: Exception) {
//            if (e is CancellationException) throw e
//            e.printStackTrace()
//            ""
//        }
        val content: String = try {
            apiClient.get(
                endpoint = JobsRemoteDataSource.jobTrace(projectId, jobId)
            )
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()
            ""
        }

        return JobLog(jobId = jobId, content = content)
    }

    /*private suspend fun fetchAndEnrichJob(projectId: Int, jobId: Long): DetailedJob {
        val detail: ApiDetailedJob = apiClient.get(
            endpoint = JobsRemoteDataSource.jobDetail(projectId, jobId)
        )
        val mapped: DetailedJob = apiDetailedJobMapper.map(detail)

        val sha = mapped.commitSha
        val commitTitle: String? = sha?.let {
            runCatching {
                apiClient.get<ApiCommit>(
                    endpoint = JobsRemoteDataSource.commit(projectId, it)
                ).title
            }.getOrNull()
        }

        return if (!commitTitle.isNullOrBlank()) mapped.copy(pipelineName = commitTitle) else mapped
    }*/
}
