package com.jetbrains.kmpapp.feature.repository.data

import com.jetbrains.kmpapp.feature.repository.domain.RepositoryRepository
import com.jetbrains.kmpapp.feature.repository.domain.model.TreeItem
import com.jetbrains.kmpapp.feature.repository.domain.model.toHierarchicalTree

internal class RepositoryRepositoryImpl(
    val remoteDataSource: RepositoryRemoteDataSource
) : RepositoryRepository {

    override suspend fun getRepositoryTree(projectId: Int?): List<TreeItem> {
        val unstructuredTree = remoteDataSource.getRepositoryTree(projectId)
        val tree = unstructuredTree.toHierarchicalTree()

        return tree
    }
}
