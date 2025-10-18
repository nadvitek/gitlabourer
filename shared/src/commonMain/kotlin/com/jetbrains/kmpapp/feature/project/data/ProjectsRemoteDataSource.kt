package com.jetbrains.kmpapp.feature.project.data

import com.jetbrains.kmpapp.feature.project.domain.model.Project

internal interface ProjectsRemoteDataSource {

    suspend fun gatherProjects(pageNumber: Int): List<Project>
    suspend fun searchProjects(text: String): List<Project>

    companion object Endpoints {
        const val AVATAR = "avatar"
        const val PROJECTS = "projects"

        fun projectsWithPage(page: Int): String {
            return if (page == 0) {
                PROJECTS
            } else {
                "$PROJECTS?page=$page"
            }
        }

        fun searchProjects(text: String): String {
            return "$PROJECTS?search=$text"
        }

        fun projectAvatar(id: Int): String {
            return "$PROJECTS/$id/$AVATAR"
        }
    }
}
