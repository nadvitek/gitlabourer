package com.jetbrains.kmpapp.core.network

import org.koin.dsl.module

val apiModule = module {
    single<ApiAttributes> {
        ApiAttributes(
            baseUrl = "https://gitlab.ack.ee",
            token = "",
        )
    }

    single<GitlabApiClient> {
        GitlabApiClient(
            apiAttributes = get(),
        )
    }
}
