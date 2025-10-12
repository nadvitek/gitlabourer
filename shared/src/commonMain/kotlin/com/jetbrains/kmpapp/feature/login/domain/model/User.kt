package com.jetbrains.kmpapp.feature.login.domain.model

public data class User(
    val id: Long,
    val username: String,
    val name: String,
    val state: String,
    val avatarUrl: String?,
    val webUrl: String,
    val email: String?
)
