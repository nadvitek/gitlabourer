package com.jetbrains.kmpapp.feature.jobs.domain.usecase

import com.jetbrains.kmpapp.feature.jobs.domain.JobsRepository
import com.jetbrains.kmpapp.feature.jobs.domain.model.JobLog
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface GetJobLogUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(projectId: Int, jobId: Long): JobLog
}

internal class GetJobLogUseCaseImpl(
    private val jobsRepository: JobsRepository
) : GetJobLogUseCase {

    override suspend fun invoke(projectId: Int, jobId: Long): JobLog {
        return jobsRepository.getJobLog(projectId, jobId)
    }
}
