package com.jetbrains.kmpapp.feature.login.data.api.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class ApiUser(
    @SerialName("id")
    val id: Long,
    @SerialName("username")
    val username: String,
    @SerialName("name")
    val name: String,
    @SerialName("state")
    val state: String,
    @SerialName("avatar_url")
    val avatarUrl: String? = null,
    @SerialName("web_url")
    val webUrl: String,
    @SerialName("email")
    val email: String? = null
)
