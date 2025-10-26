package com.jetbrains.kmpapp.feature.repository

import com.jetbrains.kmpapp.core.network.apiModule
import com.jetbrains.kmpapp.feature.mergeRequests.domain.usecase.GetRepositoryFileTreeUseCase
import com.jetbrains.kmpapp.feature.mergeRequests.domain.usecase.GetRepositoryFileTreeUseCaseImpl
import com.jetbrains.kmpapp.feature.repository.data.RepositoryRemoteDataSource
import com.jetbrains.kmpapp.feature.repository.data.RepositoryRepositoryImpl
import com.jetbrains.kmpapp.feature.repository.data.api.RepositoryKtorDataSource
import com.jetbrains.kmpapp.feature.repository.domain.RepositoryRepository
import com.jetbrains.kmpapp.feature.repository.domain.usecase.GetFileDataUseCase
import com.jetbrains.kmpapp.feature.repository.domain.usecase.GetFileDataUseCaseImpl
import com.jetbrains.kmpapp.feature.repository.domain.usecase.GetRepositoryBranchesUseCase
import com.jetbrains.kmpapp.feature.repository.domain.usecase.GetRepositoryBranchesUseCaseImpl
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
    factory<GetRepositoryBranchesUseCase> {
        GetRepositoryBranchesUseCaseImpl(
            repositoryRepository = get()
        )
    }

    factory<GetFileDataUseCase> {
        GetFileDataUseCaseImpl(
            repositoryRepository = get()
        )
    }
}
