package com.jetbrains.kmpapp.feature.project.data

import com.jetbrains.kmpapp.feature.project.domain.Project
import com.jetbrains.kmpapp.feature.project.domain.ProjectsRepository

class ProjectsRepositoryImpl(
    private val projectsRemoteDataSource: ProjectsRemoteDataSource
) : ProjectsRepository {

    override suspend fun getProjects(pageNumber: Int): List<Project> {
        return projectsRemoteDataSource.gatherProjects(pageNumber)
    }
}