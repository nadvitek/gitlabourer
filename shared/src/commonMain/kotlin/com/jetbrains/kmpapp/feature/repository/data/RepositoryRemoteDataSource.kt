package com.jetbrains.kmpapp.feature.repository.data

import com.jetbrains.kmpapp.feature.repository.domain.model.RepositoryBranch
import com.jetbrains.kmpapp.feature.repository.domain.model.TreeItem

internal interface RepositoryRemoteDataSource {
    suspend fun getRepositoryTree(projectId: Int?, branchName: String?): List<TreeItem>
    suspend fun getRepositoryBranches(projectId: Int?): List<RepositoryBranch>

    companion object Endpoints {
        const val TREE = "tree"
        const val PROJECTS = "projects"
        const val REPOSITORY = "repository"
        const val BRANCHES = "branches"

        fun getRepositoryBranches(projectId: Int?): String {
            return "$PROJECTS/${projectId}/$REPOSITORY/$BRANCHES"
        }

        fun getRepositoryTree(projectId: Int?, branchName: String?): String {
            return if (branchName != null) {
                "$PROJECTS/${projectId}/$REPOSITORY/$TREE?recursive=true&per_page=1000000"
            } else {
                "$PROJECTS/${projectId}/$REPOSITORY/$TREE?ref_name=$branchName&recursive=true&per_page=1000000"
            }
        }
    }
}
