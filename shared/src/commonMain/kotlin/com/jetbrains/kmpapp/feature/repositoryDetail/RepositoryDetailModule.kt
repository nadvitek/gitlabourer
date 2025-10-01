package com.jetbrains.kmpapp.feature.repositoryDetail

import com.jetbrains.kmpapp.core.network.apiModule
import org.koin.dsl.module

val repositoryModule = module {
    includes(apiModule)
}