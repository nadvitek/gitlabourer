package com.jetbrains.kmpapp.feature.jobs.data

import com.jetbrains.kmpapp.feature.jobs.data.api.model.ApiBridge
import com.jetbrains.kmpapp.feature.jobs.domain.model.Bridge
import com.jetbrains.kmpapp.feature.jobs.domain.model.DetailedJob
import com.jetbrains.kmpapp.feature.jobs.domain.model.JobLog

internal interface JobsRemoteDataSource {

    suspend fun getJobs(projectId: Int, pageNumber: Int): List<DetailedJob>
    suspend fun getJobsForPipeline(projectId: Int, pipelineId: Long): List<DetailedJob>
    suspend fun getBridges(projectId: Int, pipelineId: Long, pageNumber: Int = 0): List<Bridge>
    suspend fun retryJob(projectId: Int, jobId: Long): DetailedJob
    suspend fun cancelJob(projectId: Int, jobId: Long): DetailedJob
    suspend fun getJobLog(projectId: Int, jobId: Long): JobLog

    companion object Endpoints {
        const val PROJECTS = "projects"
        const val JOBS = "jobs"
        const val PIPELINES = "pipelines"
        const val REPOSITORY = "repository"
        const val COMMITS = "commits"
        const val BRIDGES = "bridges"
        const val TRACE = "trace"

        fun projectJobs(projectId: Int, page: Int): String =
            if (page == 0) "$PROJECTS/$projectId/$JOBS" else "$PROJECTS/$projectId/$JOBS?page=$page"

        fun pipelineJobs(projectId: Int, pipelineId: Long, page: Int): String =
            if (page == 0) "$PROJECTS/$projectId/$PIPELINES/$pipelineId/$JOBS"
            else "$PROJECTS/$projectId/$PIPELINES/$pipelineId/$JOBS?page=$page"

        fun jobDetail(projectId: Int, jobId: Long): String =
            "$PROJECTS/$projectId/$JOBS/$jobId"

        fun pipelineDetail(projectId: Int, pipelineId: Long): String =
            "$PROJECTS/$projectId/$PIPELINES/$pipelineId"

        fun retryJob(projectId: Int, jobId: Long): String =
            "$PROJECTS/$projectId/$JOBS/$jobId/retry"

        fun cancelJob(projectId: Int, jobId: Long): String =
            "$PROJECTS/$projectId/$JOBS/$jobId/cancel"

        fun commit(projectId: Int, sha: String): String =
            "$PROJECTS/$projectId/$REPOSITORY/$COMMITS/$sha"

        fun pipelineBridges(projectId: Int, pipelineId: Long, page: Int): String =
            if (page == 0) "$PROJECTS/$projectId/$PIPELINES/$pipelineId/$BRIDGES"
            else "$PROJECTS/$projectId/$PIPELINES/$pipelineId/$BRIDGES?page=$page"

        fun jobTrace(projectId: Int, jobId: Long): String =
            "$PROJECTS/$projectId/$JOBS/$jobId/$TRACE"
    }
}
