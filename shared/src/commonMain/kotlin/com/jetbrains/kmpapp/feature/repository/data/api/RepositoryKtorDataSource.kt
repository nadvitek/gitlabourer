package com.jetbrains.kmpapp.feature.repository.data.api

import com.jetbrains.kmpapp.core.network.GitlabApiClient
import com.jetbrains.kmpapp.feature.repository.data.RepositoryRemoteDataSource
import com.jetbrains.kmpapp.feature.repository.data.api.mapper.ApiFileDataMapper
import com.jetbrains.kmpapp.feature.repository.data.api.mapper.ApiRepositoryBranchMapper
import com.jetbrains.kmpapp.feature.repository.data.api.mapper.ApiRepositoryTreeMapper
import com.jetbrains.kmpapp.feature.repository.data.api.model.ApiFileData
import com.jetbrains.kmpapp.feature.repository.data.api.model.ApiRepositoryBranch
import com.jetbrains.kmpapp.feature.repository.data.api.model.ApiTreeItem
import com.jetbrains.kmpapp.feature.repository.domain.model.FileData
import com.jetbrains.kmpapp.feature.repository.domain.model.RepositoryBranch
import com.jetbrains.kmpapp.feature.repository.domain.model.TreeItem
import io.ktor.http.encodeURLParameter
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi

internal class RepositoryKtorDataSource(
    private val apiClient: GitlabApiClient
) : RepositoryRemoteDataSource {

    private val apiTreeItemMapper = ApiRepositoryTreeMapper()
    private val apiRepositoryBranchMapper = ApiRepositoryBranchMapper()
    private val apiFileDataMapper = ApiFileDataMapper()

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

    override suspend fun getFileData(
        projectId: Int, filePath: String, branchName: String
    ): FileData {
        val replacedFilePath = filePath.replace("/", "%2F")
        val response = apiClient.get<ApiFileData>(
            endpoint = RepositoryRemoteDataSource.getFileData(projectId, replacedFilePath, branchName)
        )

        val mapped = apiFileDataMapper.map(response)

        val decodedContent = decodeGitLabFileContent(mapped.content)

        return mapped.copy(content = decodedContent)
    }

    @OptIn(ExperimentalEncodingApi::class)
    private fun decodeGitLabFileContent(base64: String): String {
        val decodedBytes = Base64.decode(base64)
        return decodedBytes.decodeToString()
    }
}
