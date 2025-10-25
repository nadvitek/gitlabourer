package com.jetbrains.kmpapp.feature.repository.data

import com.jetbrains.kmpapp.feature.repository.domain.RepositoryRepository
import com.jetbrains.kmpapp.feature.repository.domain.model.RepositoryBranch
import com.jetbrains.kmpapp.feature.repository.domain.model.TreeItem
import com.jetbrains.kmpapp.feature.repository.domain.model.toHierarchicalTree

internal class RepositoryRepositoryImpl(
    val remoteDataSource: RepositoryRemoteDataSource
) : RepositoryRepository {

    override suspend fun getRepositoryTree(projectId: Int?, branchName: String?): List<TreeItem> {
        val unstructuredTree = remoteDataSource.getRepositoryTree(projectId, branchName)
        val tree = unstructuredTree.toHierarchicalTree()

        return tree
    }

    override suspend fun getRepositoryBranches(projectId: Int?): List<RepositoryBranch> {
        return remoteDataSource.getRepositoryBranches(projectId)
    }
}
