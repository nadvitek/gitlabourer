package com.jetbrains.kmpapp.feature.repository.data.api

import com.jetbrains.kmpapp.core.network.GitlabApiClient
import com.jetbrains.kmpapp.feature.repository.data.RepositoryRemoteDataSource
import com.jetbrains.kmpapp.feature.repository.data.api.mapper.ApiRepositoryTreeMapper
import com.jetbrains.kmpapp.feature.repository.data.api.model.ApiTreeItem
import com.jetbrains.kmpapp.feature.repository.domain.model.TreeItem
import io.ktor.http.encodeURLParameter

internal class RepositoryKtorDataSource(
    private val apiClient: GitlabApiClient
) : RepositoryRemoteDataSource {

    private val apiTreeItemMapper = ApiRepositoryTreeMapper()

    override suspend fun getRepositoryTree(projectId: Int?): List<TreeItem> {
        val response = apiClient.get<List<ApiTreeItem>>(
            endpoint = RepositoryRemoteDataSource.getRepositoryTree(projectId)
        )

        val mapped = apiTreeItemMapper.map(response)

        return mapped.sortedWith(compareBy<TreeItem> {
            when (it.kind) {
                TreeItem.Kind.DIRECTORY -> 0
                TreeItem.Kind.FILE -> 1
                TreeItem.Kind.SUBMODULE -> 2
            }
        }.thenBy { it.name.lowercase() })
    }
}
