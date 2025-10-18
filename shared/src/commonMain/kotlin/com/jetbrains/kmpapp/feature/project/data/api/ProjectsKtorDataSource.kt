package com.jetbrains.kmpapp.feature.project.data.api

import com.jetbrains.kmpapp.core.network.GitlabApiClient
import com.jetbrains.kmpapp.feature.project.data.ProjectsRemoteDataSource
import com.jetbrains.kmpapp.feature.project.data.api.mapper.ApiProjectMapper
import com.jetbrains.kmpapp.feature.project.data.api.model.ApiProject
import com.jetbrains.kmpapp.feature.project.domain.model.AvatarPayload
import com.jetbrains.kmpapp.feature.project.domain.model.Project
import io.ktor.client.call.body
import io.ktor.http.ContentType
import io.ktor.http.HttpHeaders
import io.ktor.http.isSuccess
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlin.coroutines.cancellation.CancellationException
import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi

internal class ProjectsKtorDataSource(
    private val apiClient: GitlabApiClient
) : ProjectsRemoteDataSource {

    private val apiProjectMapper = ApiProjectMapper()

    override suspend fun gatherProjects(pageNumber: Int): List<Project> = coroutineScope {
        val projects = try {
            apiClient.get<List<ApiProject>>(
                endpoint = ProjectsRemoteDataSource.projectsWithPage(pageNumber)
            )
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()
            emptyList()
        }

        projects.map { api ->
            async {
                val mapped = apiProjectMapper.map(api)
                // Try to fetch a small avatar (e.g., 64px)
                val payload = runCatching { avatarData(api.id, size = 64) }.getOrNull()
                mapped.copy(
                    avatarUrl = payload
                )
            }
        }.awaitAll()
    }

    @OptIn(ExperimentalEncodingApi::class)
    suspend fun avatarData(projectId: Int, size: Int? = null): AvatarPayload? {
        val response = apiClient.getRaw(
            endpoint = ProjectsRemoteDataSource.projectAvatar(projectId),
            accept = ContentType.Image.Any
        )

        if (!response.status.isSuccess()) return null

        val bytes: ByteArray = response.body()
        val contentType = response.headers[HttpHeaders.ContentType]
        val base64 = Base64.encode(bytes)

        return AvatarPayload(base64 = base64, contentType = contentType)
    }
}
