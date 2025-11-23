package com.jetbrains.kmpapp.core.network

import TokenSettingsDataSource
import com.jetbrains.kmpapp.core.network.data.ApiLocalDataSource
import com.jetbrains.kmpapp.core.network.data.ApiSettingsDataSource
import com.jetbrains.kmpapp.feature.token.data.TokenLocalDataSource
import org.koin.dsl.module

internal val apiModule = module {
    single<GitlabApiClient> {
        GitlabApiClient(
            tokenLocalDataSource = get(),
            apiLocalDataSource = get()
        )
    }

    single<TokenLocalDataSource> {
        TokenSettingsDataSource(
            observableSettingsFactory = get()
        )
    }

    single<ApiLocalDataSource> {
        ApiSettingsDataSource(
            observableSettingsFactory = get()
        )
    }
}
