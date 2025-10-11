package com.jetbrains.kmpapp.feature.project

import com.jetbrains.kmpapp.core.network.apiModule
import com.jetbrains.kmpapp.feature.project.data.ProjectsRemoteDataSource
import com.jetbrains.kmpapp.feature.project.data.ProjectsRepositoryImpl
import com.jetbrains.kmpapp.feature.project.data.api.ProjectsKtorDataSource
import com.jetbrains.kmpapp.feature.project.domain.GetProjectsUseCase
import com.jetbrains.kmpapp.feature.project.domain.GetProjectsUseCaseImpl
import com.jetbrains.kmpapp.feature.project.domain.ProjectsRepository
import org.koin.core.module.Module
import org.koin.dsl.module

public val projectModule: Module = module {
    includes(apiModule)

    single<ProjectsRemoteDataSource> {
        ProjectsKtorDataSource(
            apiClient = get()
        )
    }

    single<ProjectsRepository> {
        ProjectsRepositoryImpl(
            projectsRemoteDataSource = get()
        )
    }

    factory<GetProjectsUseCase> {
        GetProjectsUseCaseImpl(
            projectsRepository = get()
        )
    }
}
