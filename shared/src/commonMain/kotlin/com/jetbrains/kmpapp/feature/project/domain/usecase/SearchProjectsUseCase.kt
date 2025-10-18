package com.jetbrains.kmpapp.feature.project.domain.usecase

import com.jetbrains.kmpapp.feature.project.domain.ProjectsRepository
import com.jetbrains.kmpapp.feature.project.domain.model.Project
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface SearchProjectsUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(text: String): List<Project>
}

internal class SearchProjectsUseCaseImpl(
    private val projectsRepository: ProjectsRepository,
) : SearchProjectsUseCase {

    override suspend fun invoke(text: String): List<Project> {
        return projectsRepository.searchProjects(text)
    }
}
