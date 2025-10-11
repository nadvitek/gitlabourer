package com.jetbrains.kmpapp.feature.project.domain

import com.jetbrains.kmpapp.feature.project.domain.data.Project
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface GetProjectsUseCase {

    @Throws(Throwable::class)
    suspend operator fun invoke(pageNumber: Int): List<Project>
}

internal class GetProjectsUseCaseImpl(
    private val projectsRepository: ProjectsRepository,
) : GetProjectsUseCase {

    override suspend fun invoke(pageNumber: Int): List<Project> {
        return projectsRepository.getProjects(pageNumber)
    }
}
