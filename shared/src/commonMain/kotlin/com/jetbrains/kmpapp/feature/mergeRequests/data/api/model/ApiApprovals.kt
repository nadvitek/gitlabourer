package com.jetbrains.kmpapp.feature.mergeRequests.data.api.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class ApiApprovals(
    @SerialName("approved")
    val approved: Boolean,
)
