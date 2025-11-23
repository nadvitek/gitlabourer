package com.jetbrains.kmpapp.feature.pipelines.data

import com.jetbrains.kmpapp.feature.pipelines.domain.model.PipelinesPage

internal interface PipelinesRemoteDataSource {

    suspend fun getPipelines(projectId: Int, pageNumber: Int): PipelinesPage

    companion object Endpoints {
        const val PIPELINES = "pipelines"
        const val PROJECTS = "projects"
        const val COMMITS = "commits"
        const val REPOSITORY = "repository"

        fun projectsWithPage(page: Int): String {
            return if (page == 0) {
                PROJECTS
            } else {
                "$PROJECTS?page=$page"
            }
        }

        fun detailedPipeline(projectId: Int, pipelineId: Int): String {
            return "$PROJECTS/$projectId/$PIPELINES/$pipelineId"
        }

        fun projectPipelines(id: Int, page: Int): String {
            return if (page == 0) {
                "$PROJECTS/$id/$PIPELINES"
            } else {
                "$PROJECTS/$id/$PIPELINES?page=$page"
            }
        }

        fun pipelineName(projectId: Int, sha: String): String {
            return "$PROJECTS/$projectId/$REPOSITORY/$COMMITS/$sha"
        }
    }
}
