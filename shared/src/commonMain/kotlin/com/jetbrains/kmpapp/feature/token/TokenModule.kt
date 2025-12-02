package com.jetbrains.kmpapp.feature.token

import com.jetbrains.kmpapp.feature.token.data.TokenSettingsDataSource
import com.jetbrains.kmpapp.feature.token.data.TokenLocalDataSource
import com.jetbrains.kmpapp.feature.token.domain.GetTokenUseCase
import com.jetbrains.kmpapp.feature.token.domain.GetTokenUseCaseImpl
import org.koin.dsl.module

internal val tokenModule = module {
    single<TokenLocalDataSource> {
        TokenSettingsDataSource(
            observableSettingsFactory = get()
        )
    }
    factory<GetTokenUseCase> {
        GetTokenUseCaseImpl(
            tokenLocalDataSource = get(),
        )
    }
}
