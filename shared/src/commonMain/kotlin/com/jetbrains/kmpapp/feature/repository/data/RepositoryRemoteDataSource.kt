package com.jetbrains.kmpapp.feature.repository.data

import com.jetbrains.kmpapp.feature.repository.domain.model.TreeItem

internal interface RepositoryRemoteDataSource {
    suspend fun getRepositoryTree(projectId: Int?): List<TreeItem>

    companion object Endpoints {
        const val TREE = "tree"
        const val PROJECTS = "projects"
        const val REPOSITORY = "repository"

        fun getRepositoryTree(projectId: Int?): String {
            return "$PROJECTS/${projectId}/$REPOSITORY/$TREE?recursive=true&per_page=1000000"
        }
    }
}
