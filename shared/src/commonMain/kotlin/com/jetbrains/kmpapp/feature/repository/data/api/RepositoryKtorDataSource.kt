package com.jetbrains.kmpapp.feature.repository.data.api

import com.jetbrains.kmpapp.core.network.GitlabApiClient
import com.jetbrains.kmpapp.feature.repository.data.RepositoryRemoteDataSource
import com.jetbrains.kmpapp.feature.repository.data.api.mapper.ApiRepositoryBranchMapper
import com.jetbrains.kmpapp.feature.repository.data.api.mapper.ApiRepositoryTreeMapper
import com.jetbrains.kmpapp.feature.repository.data.api.model.ApiRepositoryBranch
import com.jetbrains.kmpapp.feature.repository.data.api.model.ApiTreeItem
import com.jetbrains.kmpapp.feature.repository.domain.model.RepositoryBranch
import com.jetbrains.kmpapp.feature.repository.domain.model.TreeItem
import io.ktor.http.encodeURLParameter

internal class RepositoryKtorDataSource(
    private val apiClient: GitlabApiClient
) : RepositoryRemoteDataSource {

    private val apiTreeItemMapper = ApiRepositoryTreeMapper()
    private val apiRepositoryBranchMapper = ApiRepositoryBranchMapper()

    override suspend fun getRepositoryTree(projectId: Int?, branchName: String?): List<TreeItem> {
        val response = apiClient.get<List<ApiTreeItem>>(
            endpoint = RepositoryRemoteDataSource.getRepositoryTree(projectId, branchName)
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

    override suspend fun getRepositoryBranches(projectId: Int?): List<RepositoryBranch> {
        val response = apiClient.get<List<ApiRepositoryBranch>>(
            endpoint = RepositoryRemoteDataSource.getRepositoryBranches(projectId)
        )

        val mapped = response.map(apiRepositoryBranchMapper::map)

        return mapped
    }
}
