package com.jetbrains.kmpapp.feature.repository.domain

import com.jetbrains.kmpapp.feature.repository.domain.model.TreeItem

internal interface RepositoryRepository {
    suspend fun getRepositoryTree(projectId: Int?): List<TreeItem>
}
