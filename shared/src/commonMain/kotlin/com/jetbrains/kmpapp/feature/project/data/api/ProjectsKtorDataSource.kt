package com.jetbrains.kmpapp.feature.project.data.api

import com.jetbrains.kmpapp.core.network.GitlabApiClient
import com.jetbrains.kmpapp.feature.project.data.ProjectsRemoteDataSource
import com.jetbrains.kmpapp.feature.project.domain.Project
import kotlin.coroutines.cancellation.CancellationException

internal class ProjectsKtorDataSource(
    private val apiClient: GitlabApiClient
) : ProjectsRemoteDataSource {

    override suspend fun gatherProjects(pageNumber: Int) : List<Project> {
        return try {
            apiClient.get(
                endpoint = ProjectsRemoteDataSource.projectsWithPage(pageNumber)
            )
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()

            emptyList()
        }
    }
}