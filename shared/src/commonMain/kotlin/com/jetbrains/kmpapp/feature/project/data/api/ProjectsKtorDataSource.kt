package com.jetbrains.kmpapp.feature.project.data.api

import com.jetbrains.kmpapp.core.mapper.ApiPagedResponseMapper
import com.jetbrains.kmpapp.core.model.domain.PageInfo
import com.jetbrains.kmpapp.core.network.GitlabApiClient
import com.jetbrains.kmpapp.feature.project.data.ProjectsRemoteDataSource
import com.jetbrains.kmpapp.feature.project.data.api.mapper.ApiProjectMapper
import com.jetbrains.kmpapp.feature.project.data.api.model.ApiProject
import com.jetbrains.kmpapp.feature.project.domain.model.AvatarPayload
import com.jetbrains.kmpapp.feature.project.domain.model.Project
import com.jetbrains.kmpapp.feature.project.domain.model.ProjectsPage
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
    private val apiPagedResponseMapper = ApiPagedResponseMapper()

    override suspend fun gatherProjects(pageNumber: Int): ProjectsPage = coroutineScope {
        val paged = try {
            apiClient.getPaged<List<ApiProject>>(
                endpoint = ProjectsRemoteDataSource.projectsWithPage(pageNumber)
            )
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()
            return@coroutineScope ProjectsPage(
                items = emptyList(),
                PageInfo(
                    currentPage = pageNumber,
                    nextPage = null,
                    totalPages = null,
                    totalItems = null,
                    perPage = null
                )
            )
        }

        val mappedItems = paged.response.map { api ->
            async {
                val mapped = apiProjectMapper.map(api)

                if (api.avatarUrl != null) {
                    val payload = runCatching { avatarData(api.id, size = 64) }.getOrNull()
                    mapped.copy(avatarUrl = payload)
                } else {
                    mapped
                }
            }
        }.awaitAll()

        val pageInfo = apiPagedResponseMapper.map(paged)

        ProjectsPage(
            items = mappedItems,
            pageInfo = pageInfo
        )
    }

    override suspend fun searchProjects(text: String): List<Project> = coroutineScope {
        val projects = try {
            apiClient.get<List<ApiProject>>(
                endpoint = ProjectsRemoteDataSource.searchProjects(text)
            )
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()
            emptyList()
        }

        projects.map { api ->
            async {
                val mapped = apiProjectMapper.map(api)
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
