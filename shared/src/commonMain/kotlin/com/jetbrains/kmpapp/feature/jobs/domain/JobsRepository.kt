package com.jetbrains.kmpapp.feature.jobs.domain

import com.jetbrains.kmpapp.feature.jobs.domain.model.Bridge
import com.jetbrains.kmpapp.feature.jobs.domain.model.DetailedJob
import com.jetbrains.kmpapp.feature.jobs.domain.model.JobLog
import com.jetbrains.kmpapp.feature.jobs.domain.model.JobsPage

internal interface JobsRepository {
    suspend fun getJobs(projectId: Int, pageNumber: Int): JobsPage
    suspend fun getJobsForPipeline(projectId: Int, pipelineId: Long): List<DetailedJob>
    suspend fun getBridges(projectId: Int, pipelineId: Long, pageNumber: Int = 0): List<Bridge>
    suspend fun retryJob(projectId: Int, jobId: Long): DetailedJob
    suspend fun cancelJob(projectId: Int, jobId: Long): DetailedJob
    suspend fun getJobLog(projectId: Int, jobId: Long): JobLog
}
