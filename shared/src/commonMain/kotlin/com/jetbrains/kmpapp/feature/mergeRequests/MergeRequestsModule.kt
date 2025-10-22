package com.jetbrains.kmpapp.feature.mergeRequests

import com.jetbrains.kmpapp.core.network.apiModule
import com.jetbrains.kmpapp.feature.mergeRequests.data.MergeRequestsRemoteDataSource
import com.jetbrains.kmpapp.feature.mergeRequests.data.MergeRequestsRepositoryImpl
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.MergeRequestsKtorDataSource
import com.jetbrains.kmpapp.feature.mergeRequests.domain.MergeRequestsRepository
import com.jetbrains.kmpapp.feature.mergeRequests.domain.usecase.GetMergeRequestsUseCase
import com.jetbrains.kmpapp.feature.mergeRequests.domain.usecase.GetMergeRequestsUseCaseImpl
import org.koin.core.module.Module
import org.koin.dsl.module

public val mergeRequestsModule: Module = module {
    includes(apiModule)

    single<MergeRequestsRemoteDataSource> {
        MergeRequestsKtorDataSource(
            apiClient = get()
        )
    }

    single<MergeRequestsRepository> {
        MergeRequestsRepositoryImpl(
            mergeRequestsRemoteDataSource = get()
        )
    }

    factory<GetMergeRequestsUseCase> {
        GetMergeRequestsUseCaseImpl(
            mergeRequestsRepository = get()
        )
    }
}
