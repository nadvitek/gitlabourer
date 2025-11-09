package com.jetbrains.kmpapp.feature.jobs

import com.jetbrains.kmpapp.core.network.apiModule
import com.jetbrains.kmpapp.feature.jobs.data.JobsRemoteDataSource
import com.jetbrains.kmpapp.feature.jobs.data.JobsRepositoryImpl
import com.jetbrains.kmpapp.feature.jobs.data.api.JobsKtorDataSource
import com.jetbrains.kmpapp.feature.jobs.domain.JobsRepository
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.CancelJobUseCase
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.CancelJobUseCaseImpl
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.GetJobLogUseCase
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.GetJobLogUseCaseImpl
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.GetJobsForPipelineUseCase
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.GetJobsForPipelineUseCaseImpl
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.GetJobsForProjectUseCase
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.GetJobsForProjectUseCaseImpl
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.RetryJobUseCase
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.RetryJobUseCaseImpl
import org.koin.core.module.Module
import org.koin.dsl.module

public val jobsModule: Module = module {
    includes(apiModule)

    single<JobsRemoteDataSource> {
        JobsKtorDataSource(
            apiClient = get()
        )
    }

    single<JobsRepository> {
        JobsRepositoryImpl(
            remoteDataSource = get()
        )
    }

    factory<GetJobsForProjectUseCase> {
        GetJobsForProjectUseCaseImpl(
            jobsRepository = get()
        )
    }

    factory<GetJobsForPipelineUseCase> {
        GetJobsForPipelineUseCaseImpl(
            jobsRepository = get()
        )
    }

    factory<RetryJobUseCase> {
        RetryJobUseCaseImpl(
            jobsRepository = get()
        )
    }

    factory<CancelJobUseCase> {
        CancelJobUseCaseImpl(
            jobsRepository = get()
        )
    }

    factory<GetJobLogUseCase> {
        GetJobLogUseCaseImpl(
            jobsRepository = get()
        )
    }
}
