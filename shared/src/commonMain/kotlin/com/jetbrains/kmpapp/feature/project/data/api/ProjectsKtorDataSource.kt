package com.jetbrains.kmpapp.feature.project.data.api

import com.jetbrains.kmpapp.core.network.GitlabApiClient
import com.jetbrains.kmpapp.feature.project.data.ProjectsRemoteDataSource
import com.jetbrains.kmpapp.feature.project.data.api.mapper.ApiProjectMapper
import com.jetbrains.kmpapp.feature.project.data.api.model.ApiProject
import com.jetbrains.kmpapp.feature.project.domain.data.Project
import kotlin.coroutines.cancellation.CancellationException

internal class ProjectsKtorDataSource(
    private val apiClient: GitlabApiClient
) : ProjectsRemoteDataSource {

    private val apiProjectMapper = ApiProjectMapper()

    override suspend fun gatherProjects(pageNumber: Int) : List<Project> {
        return try {
            val projects = apiClient.get<List<ApiProject>>(
                endpoint = ProjectsRemoteDataSource.projectsWithPage(pageNumber)
            )

            return projects.map { apiProjectMapper.map(it) }
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()

            emptyList()
        }
    }
}
