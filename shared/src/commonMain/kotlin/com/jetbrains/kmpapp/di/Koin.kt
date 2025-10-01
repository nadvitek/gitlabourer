package com.jetbrains.kmpapp.di

import com.jetbrains.kmpapp.feature.project.domain.GetProjectsUseCase
import com.jetbrains.kmpapp.feature.project.projectModule
import com.jetbrains.kmpapp.feature.repository.repositoryDetailModule
import org.koin.core.component.KoinComponent
import org.koin.core.component.get
import org.koin.core.context.startKoin
import org.koin.core.module.Module

fun initKoin(extraModules: List<Module>) {
    startKoin {
        modules(
            projectModule,
            repositoryDetailModule,
            *extraModules.toTypedArray(),
        )
    }
}

public class AppDependency : KoinComponent {

    public val projectsUseCase: GetProjectsUseCase
        get() = get()
}