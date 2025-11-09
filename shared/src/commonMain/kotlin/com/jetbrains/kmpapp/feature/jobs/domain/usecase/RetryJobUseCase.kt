package com.jetbrains.kmpapp.feature.jobs.domain.usecase

import com.jetbrains.kmpapp.feature.jobs.domain.JobsRepository
import com.jetbrains.kmpapp.feature.jobs.domain.model.DetailedJob
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface RetryJobUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(projectId: Int, jobId: Long): DetailedJob
}

internal class RetryJobUseCaseImpl(
    private val jobsRepository: JobsRepository
) : RetryJobUseCase {

    override suspend fun invoke(projectId: Int, jobId: Long): DetailedJob {
        return jobsRepository.retryJob(projectId, jobId)
    }
}
