package com.jetbrains.kmpapp.feature.project.domain

import com.jetbrains.kmpapp.feature.project.domain.model.Project

internal interface ProjectsRepository {
    suspend fun getProjects(pageNumber: Int) : List<Project>
}
