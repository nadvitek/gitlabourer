package com.jetbrains.kmpapp.feature.login

import com.jetbrains.kmpapp.core.network.apiModule
import com.jetbrains.kmpapp.feature.login.data.LoginRemoteDataSource
import com.jetbrains.kmpapp.feature.login.data.LoginRepositoryImpl
import com.jetbrains.kmpapp.feature.login.data.api.LoginKtorDataSource
import com.jetbrains.kmpapp.feature.login.domain.LoginRepository
import com.jetbrains.kmpapp.feature.login.domain.usecase.GetUserUseCase
import com.jetbrains.kmpapp.feature.login.domain.usecase.GetUserUseCaseImpl
import com.jetbrains.kmpapp.feature.login.domain.usecase.LoginUseCase
import com.jetbrains.kmpapp.feature.login.domain.usecase.LoginUseCaseImpl
import com.jetbrains.kmpapp.feature.login.domain.usecase.LogoutUseCase
import com.jetbrains.kmpapp.feature.login.domain.usecase.LogoutUseCaseImpl
import org.koin.core.module.Module
import org.koin.dsl.module

internal val loginModule: Module = module {
    includes(apiModule)

    single<LoginRemoteDataSource> {
        LoginKtorDataSource(
            apiClient = get()
        )
    }

    single<LoginRepository> {
        LoginRepositoryImpl(
            loginRemoteDataSource = get()
        )
    }

    factory<LoginUseCase> {
        LoginUseCaseImpl(
            tokenLocalDataSource = get(),
            apiLocalDataSource = get(),
            userLocalDataSource = get(),
            loginRepository = get(),
        )
    }

    factory<LogoutUseCase> {
        LogoutUseCaseImpl(
            tokenLocalDataSource = get(),
            apiLocalDataSource = get()
        )
    }

    factory<GetUserUseCase> {
        GetUserUseCaseImpl(
            loginRepository = get(),
        )
    }
}
