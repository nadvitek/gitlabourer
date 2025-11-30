package com.jetbrains.kmpapp.feature.mergeRequestDetail

import com.jetbrains.kmpapp.core.network.apiModule
import com.jetbrains.kmpapp.feature.mergeRequestDetail.data.MergeRequestDetailRemoteDataSource
import com.jetbrains.kmpapp.feature.mergeRequestDetail.data.MergeRequestDetailRepositoryImpl
import com.jetbrains.kmpapp.feature.mergeRequestDetail.data.api.MergeRequestDetailKtorDataSource
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.MergeRequestDetailRepository
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.usecase.ChangeMergeRequestApprovalUseCase
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.usecase.ChangeMergeRequestApprovalUseCaseImpl
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.usecase.GetMergeRequestDetailUseCase
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.usecase.GetMergeRequestDetailUseCaseImpl
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.usecase.MergeMergeRequestUseCase
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.usecase.MergeMergeRequestUseCaseImpl
import org.koin.core.module.Module
import org.koin.dsl.module

public val mergeRequestDetailModule: Module = module {
    includes(apiModule)

    single<MergeRequestDetailRemoteDataSource> {
        MergeRequestDetailKtorDataSource(
            apiClient = get()
        )
    }

    single<MergeRequestDetailRepository> {
        MergeRequestDetailRepositoryImpl(
            mergeRequestDetailRemoteDataSource = get()
        )
    }

    factory<GetMergeRequestDetailUseCase> {
        GetMergeRequestDetailUseCaseImpl(
            repository = get()
        )
    }

    factory<MergeMergeRequestUseCase> {
        MergeMergeRequestUseCaseImpl(
            repository = get()
        )
    }

    factory<ChangeMergeRequestApprovalUseCase> {
        ChangeMergeRequestApprovalUseCaseImpl(
            repository = get()
        )
    }
}
