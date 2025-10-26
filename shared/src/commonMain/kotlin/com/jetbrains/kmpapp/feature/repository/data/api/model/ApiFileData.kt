package com.jetbrains.kmpapp.feature.repository.data.api.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class ApiFileData(
    @SerialName("file_name")
    val fileName: String,
    @SerialName("ref")
    val ref: String,
    @SerialName("content")
    val content: String,
)
