package com.jetbrains.kmpapp.feature.project

import com.jetbrains.kmpapp.core.network.apiModule
import com.jetbrains.kmpapp.feature.project.data.ProjectsRemoteDataSource
import com.jetbrains.kmpapp.feature.project.data.ProjectsRepositoryImpl
import com.jetbrains.kmpapp.feature.project.data.api.ProjectsKtorDataSource
import com.jetbrains.kmpapp.feature.project.domain.GetProjectsUseCase
import com.jetbrains.kmpapp.feature.project.domain.GetProjectsUseCaseImpl
import com.jetbrains.kmpapp.feature.project.domain.ProjectsRepository
import org.koin.dsl.module

val projectModule = module {
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

    /*single<MuseumStorage> { InMemoryMuseumStorage() }
    single {
        MuseumRepository(get(), get()).apply {
            initialize()
        }
    }
     */
}