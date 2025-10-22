package com.jetbrains.kmpapp.feature.mergeRequests.data.api.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class ApiPipeline(
    @SerialName("id")
    val id: Long,
    @SerialName("sha")
    val sha: String,
    @SerialName("ref")
    val ref: String,
    @SerialName("status")
    val status: String
)
