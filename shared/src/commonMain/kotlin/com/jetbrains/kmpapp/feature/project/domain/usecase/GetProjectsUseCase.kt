package com.jetbrains.kmpapp.feature.project.domain.usecase

import com.jetbrains.kmpapp.feature.project.domain.ProjectsRepository
import com.jetbrains.kmpapp.feature.project.domain.model.Project
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface GetProjectsUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(pageNumber: Int): List<Project>
}

internal class GetProjectsUseCaseImpl(
    private val projectsRepository: ProjectsRepository,
) : GetProjectsUseCase {

    override suspend fun invoke(pageNumber: Int): List<Project> {
        return projectsRepository.getProjects(pageNumber)
    }
}
