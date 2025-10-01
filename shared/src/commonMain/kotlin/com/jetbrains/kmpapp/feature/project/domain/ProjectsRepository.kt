package com.jetbrains.kmpapp.feature.project.domain

interface ProjectsRepository {
    suspend fun getProjects(pageNumber: Int) : List<Project>
}