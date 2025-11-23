package com.jetbrains.kmpapp.feature.project.domain.model

import com.jetbrains.kmpapp.core.model.domain.PageInfo

public data class ProjectsPage(
    val items: List<Project>,
    val pageInfo: PageInfo
)
