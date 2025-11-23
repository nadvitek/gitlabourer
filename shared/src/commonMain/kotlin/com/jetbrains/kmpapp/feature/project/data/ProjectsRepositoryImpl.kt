package com.jetbrains.kmpapp.feature.project.data

import com.jetbrains.kmpapp.feature.project.domain.ProjectsRepository
import com.jetbrains.kmpapp.feature.project.domain.model.Project
import com.jetbrains.kmpapp.feature.project.domain.model.ProjectsPage

internal class ProjectsRepositoryImpl(
    private val projectsRemoteDataSource: ProjectsRemoteDataSource
) : ProjectsRepository {

    override suspend fun getProjects(pageNumber: Int): ProjectsPage {
        return projectsRemoteDataSource.gatherProjects(pageNumber)
    }

    override suspend fun searchProjects(text: String): List<Project> {
        return projectsRemoteDataSource.searchProjects(text)
    }
}
