package com.jetbrains.kmpapp.core.network

import TokenSettingsDataSource
import com.jetbrains.kmpapp.feature.token.data.TokenLocalDataSource
import org.koin.dsl.module

internal val apiModule = module {
    single<ApiAttributes> {
        ApiAttributes(
            baseUrl = "https://gitlab.ack.ee",
            token = "",
        )
    }

    single<GitlabApiClient> {
        GitlabApiClient(
            apiAttributes = get(),
            tokenLocalDataSource = get(),
        )
    }

    single<TokenLocalDataSource> {
        TokenSettingsDataSource(
            observableSettingsFactory = get()
        )
    }
}
