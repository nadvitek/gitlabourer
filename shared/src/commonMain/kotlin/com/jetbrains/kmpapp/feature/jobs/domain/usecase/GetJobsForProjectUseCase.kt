package com.jetbrains.kmpapp.feature.jobs.domain.usecase

import com.jetbrains.kmpapp.feature.jobs.domain.JobsRepository
import com.jetbrains.kmpapp.feature.jobs.domain.model.DetailedJob
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface GetJobsForProjectUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(projectId: Int, pageNumber: Int): List<DetailedJob>
}

internal class GetJobsForProjectUseCaseImpl(
    private val jobsRepository: JobsRepository
) : GetJobsForProjectUseCase {

    override suspend fun invoke(projectId: Int, pageNumber: Int): List<DetailedJob> {
        return jobsRepository.getJobs(projectId, pageNumber)
    }
}
