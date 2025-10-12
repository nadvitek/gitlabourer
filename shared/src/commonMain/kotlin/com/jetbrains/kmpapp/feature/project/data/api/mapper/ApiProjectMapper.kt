package com.jetbrains.kmpapp.feature.project.data.api.mapper

import com.jetbrains.kmpapp.feature.project.data.api.model.ApiNamespace
import com.jetbrains.kmpapp.feature.project.data.api.model.ApiOwner
import com.jetbrains.kmpapp.feature.project.data.api.model.ApiProject
import com.jetbrains.kmpapp.feature.project.domain.model.Namespace
import com.jetbrains.kmpapp.feature.project.domain.model.Owner
import com.jetbrains.kmpapp.feature.project.domain.model.Project

internal class ApiProjectMapper {
    fun map(api: ApiProject): Project = Project(
        id = api.id,
        name = api.name,
        description = api.description,
        webUrl = api.webUrl,
        visibility = api.visibility,
        createdAt = api.createdAt,
        lastActivityAt = api.lastActivityAt,
        namespace = map(api.namespace),
        owner = api.owner?.let(::map)
    )

    private fun map(api: ApiNamespace): Namespace = Namespace(
        id = api.id,
        name = api.name,
        path = api.path
    )

    private fun map(api: ApiOwner): Owner = Owner(
        id = api.id,
        username = api.username,
        name = api.name,
        state = api.state,
        avatarUrl = api.avatarUrl
    )
}
