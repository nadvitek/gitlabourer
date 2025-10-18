package com.jetbrains.kmpapp.feature.project.domain

import com.jetbrains.kmpapp.feature.project.domain.model.Project

internal interface ProjectsRepository {
    suspend fun getProjects(pageNumber: Int): List<Project>
    suspend fun searchProjects(text: String): List<Project>
}
