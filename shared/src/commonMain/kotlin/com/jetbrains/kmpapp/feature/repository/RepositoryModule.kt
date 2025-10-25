package com.jetbrains.kmpapp.feature.repository

import com.jetbrains.kmpapp.core.network.apiModule
import com.jetbrains.kmpapp.feature.mergeRequests.domain.usecase.GetRepositoryFileTreeUseCase
import com.jetbrains.kmpapp.feature.mergeRequests.domain.usecase.GetRepositoryFileTreeUseCaseImpl
import com.jetbrains.kmpapp.feature.repository.data.RepositoryRemoteDataSource
import com.jetbrains.kmpapp.feature.repository.data.RepositoryRepositoryImpl
import com.jetbrains.kmpapp.feature.repository.data.api.RepositoryKtorDataSource
import com.jetbrains.kmpapp.feature.repository.domain.RepositoryRepository
import org.koin.dsl.module

internal val repositoryDetailModule = module {
    includes(apiModule)

    single<RepositoryRemoteDataSource> {
        RepositoryKtorDataSource(
            apiClient = get()
        )
    }

    single<RepositoryRepository> {
        RepositoryRepositoryImpl(
            remoteDataSource = get()
        )
    }

    factory<GetRepositoryFileTreeUseCase> {
        GetRepositoryFileTreeUseCaseImpl(
            repositoryRepository = get()
        )
    }
}
