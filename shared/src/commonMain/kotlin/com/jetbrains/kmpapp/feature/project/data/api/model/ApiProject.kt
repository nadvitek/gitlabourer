package com.jetbrains.kmpapp.feature.project.data.api.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class ApiProject(
    @SerialName("id")
    internal val id: Int,
    @SerialName("name")
    internal val name: String,
    @SerialName("description")
    internal val description: String? = null,
    @SerialName("web_url")
    internal val webUrl: String,
    @SerialName("visibility")
    internal val visibility: String,
    @SerialName("created_at")
    internal val createdAt: String,
    @SerialName("last_activity_at")
    internal val lastActivityAt: String,
    @SerialName("namespace")
    internal val namespace: ApiNamespace,
    @SerialName("owner")
    internal val owner: ApiOwner? = null
)

@Serializable
internal data class ApiNamespace(
    @SerialName("id")
    internal val id: Int,
    @SerialName("name")
    internal val name: String,
    @SerialName("path")
    internal val path: String
)

@Serializable
internal data class ApiOwner(
    @SerialName("id")
    internal val id: Int,
    @SerialName("username")
    internal val username: String,
    @SerialName("name")
    internal val name: String,
    @SerialName("state")
    internal val state: String,
    @SerialName("avatar_url")
    internal val avatarUrl: String?
)
