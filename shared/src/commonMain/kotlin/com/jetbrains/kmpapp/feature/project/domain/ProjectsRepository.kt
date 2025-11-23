package com.jetbrains.kmpapp.feature.project.domain

import com.jetbrains.kmpapp.feature.project.domain.model.Project
import com.jetbrains.kmpapp.feature.project.domain.model.ProjectsPage

internal interface ProjectsRepository {
    suspend fun getProjects(pageNumber: Int): ProjectsPage
    suspend fun searchProjects(text: String): List<Project>
}
