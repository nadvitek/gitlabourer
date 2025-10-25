package com.jetbrains.kmpapp.feature.repository.domain

import com.jetbrains.kmpapp.feature.repository.domain.model.RepositoryBranch
import com.jetbrains.kmpapp.feature.repository.domain.model.TreeItem

internal interface RepositoryRepository {
    suspend fun getRepositoryTree(projectId: Int?, branchName: String?): List<TreeItem>
    suspend fun getRepositoryBranches(projectId: Int?): List<RepositoryBranch>
}
