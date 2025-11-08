package com.jetbrains.kmpapp.core.model.api

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class ApiCommit(
    @SerialName("id")
    val id: String,
    @SerialName("title")
    val title: String
)
