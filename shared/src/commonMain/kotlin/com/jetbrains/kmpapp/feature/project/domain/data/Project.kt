package com.jetbrains.kmpapp.feature.project.domain.data

public data class Project(
    public val id: Int,
    public val name: String,
    public val description: String?,
    public val webUrl: String,
    public val visibility: String,
    public val createdAt: String,
    public val lastActivityAt: String,
    public val namespace: Namespace,
    public val owner: Owner?
)

public data class Namespace(
    public val id: Int,
    public val name: String,
    public val path: String
)

public data class Owner(
    public val id: Int,
    public val username: String,
    public val name: String,
    public val state: String,
    public val avatarUrl: String?
)
