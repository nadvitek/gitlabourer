package com.jetbrains.kmpapp.feature.pipelines

import com.jetbrains.kmpapp.core.network.apiModule
import com.jetbrains.kmpapp.feature.pipelines.data.PipelinesRemoteDataSource
import com.jetbrains.kmpapp.feature.pipelines.data.PipelinesRepositoryImpl
import com.jetbrains.kmpapp.feature.pipelines.data.api.PipelinesKtorDataSource
import com.jetbrains.kmpapp.feature.pipelines.domain.PipelinesRepository
import com.jetbrains.kmpapp.feature.pipelines.domain.usecase.GetPipelinesForProjectUseCase
import com.jetbrains.kmpapp.feature.pipelines.domain.usecase.GetPipelinesForProjectUseCaseImpl
import org.koin.core.module.Module
import org.koin.dsl.module

public val pipelinesModule: Module = module {
    includes(apiModule)

    single<PipelinesRemoteDataSource> {
        PipelinesKtorDataSource(
            apiClient = get()
        )
    }

    single<PipelinesRepository> {
        PipelinesRepositoryImpl(
            remoteDataSource = get()
        )
    }

    factory<GetPipelinesForProjectUseCase> {
        GetPipelinesForProjectUseCaseImpl(
            pipelinesRepository = get()
        )
    }
}
