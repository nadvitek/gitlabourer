package com.jetbrains.kmpapp.feature.repositoryDetail

import com.jetbrains.kmpapp.core.network.apiModule
import org.koin.dsl.module

internal val repositoryModule = module {
    includes(apiModule)
}
