package com.jetbrains.kmpapp.feature.mergeRequests.data.api.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class ApiLabel(
    @SerialName("name")
    val name: String,
    @SerialName("color")
    val color: String,
    @SerialName("text_color")
    val textColor: String
)
