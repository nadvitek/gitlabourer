package com.jetbrains.kmpapp.feature.project.domain

import com.jetbrains.kmpapp.feature.project.domain.data.Project

interface ProjectsRepository {
    suspend fun getProjects(pageNumber: Int) : List<Project>
}
