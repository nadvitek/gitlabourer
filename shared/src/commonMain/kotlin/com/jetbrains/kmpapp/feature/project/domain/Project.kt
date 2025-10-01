package com.jetbrains.kmpapp.feature.project.domain

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class Project(
    val id: Int,
    val name: String,
    val description: String?,
    @SerialName("web_url")
    val webUrl: String,
    val visibility: String,
    @SerialName("created_at")
    val createdAt: String,
    @SerialName("last_activity_at")
    val lastActivityAt: String,
    val namespace: Namespace,
    val owner: Owner?
)

@Serializable
data class Namespace(
    val id: Int,
    val name: String,
    val path: String
)

@Serializable
data class Owner(
    val id: Int,
    val username: String,
    val name: String,
    val state: String,
    @SerialName("avatar_url")
    val avatarUrl: String? = null
)

