package com.jetbrains.kmpapp.di

import com.jetbrains.kmpapp.feature.project.domain.GetProjectsUseCase
import com.jetbrains.kmpapp.feature.project.projectModule
import com.jetbrains.kmpapp.feature.repository.repositoryDetailModule
import com.jetbrains.kmpapp.feature.token.tokenModule
import org.koin.core.component.KoinComponent
import org.koin.core.component.get
import org.koin.core.context.startKoin
import org.koin.core.module.Module

public fun initKoin(extraModules: List<Module>) {
    startKoin {
        modules(
            projectModule,
            repositoryDetailModule,
            tokenModule,
            platformSpecificModule,
            *extraModules.toTypedArray(),
        )
    }
}

public class AppDependency : KoinComponent {

    public val getProjectsUseCase: GetProjectsUseCase
        get() = get()
}
