package com.jetbrains.kmpapp.feature.mergeRequestDetail.data.api.model

import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiLabel
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class ApiMergeRequestsLabels(
    @SerialName("iid")
    val iid: Long,
    @SerialName("labels")
    val labels: List<ApiLabel>,
)
