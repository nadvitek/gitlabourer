package com.jetbrains.kmpapp.feature.jobs.data

import com.jetbrains.kmpapp.feature.jobs.data.api.model.ApiBridge
import com.jetbrains.kmpapp.feature.jobs.domain.JobsRepository
import com.jetbrains.kmpapp.feature.jobs.domain.model.Bridge
import com.jetbrains.kmpapp.feature.jobs.domain.model.DetailedJob
import com.jetbrains.kmpapp.feature.jobs.domain.model.JobLog

internal class JobsRepositoryImpl(
    private val remoteDataSource: JobsRemoteDataSource
) : JobsRepository {
    override suspend fun getJobs(projectId: Int, pageNumber: Int): List<DetailedJob> {
        return remoteDataSource.getJobs(projectId, pageNumber)
    }

    override suspend fun getJobsForPipeline(
        projectId: Int,
        pipelineId: Long
    ): List<DetailedJob> {
        return remoteDataSource.getJobsForPipeline(projectId, pipelineId)
    }

    override suspend fun getBridges(projectId: Int, pipelineId: Long, pageNumber: Int): List<Bridge> {
        return remoteDataSource.getBridges(projectId, pipelineId, pageNumber)
    }

    override suspend fun retryJob(projectId: Int, jobId: Long): DetailedJob {
        return remoteDataSource.retryJob(projectId, jobId)
    }

    override suspend fun cancelJob(projectId: Int, jobId: Long): DetailedJob {
        return remoteDataSource.cancelJob(projectId, jobId)
    }

    override suspend fun getJobLog(projectId: Int, jobId: Long): JobLog {
        return remoteDataSource.getJobLog(projectId, jobId)
    }
}
