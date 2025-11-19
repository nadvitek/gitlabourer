package com.jetbrains.kmpapp.feature.notification.data.api.model

import kotlinx.datetime.Instant

public data class FirebasePipelineStatus(
    val userId: String = "",
    val projectId: Long = 0,
    val mrIid: Long = 0,
    val mrTitle: String = "",
    val pipelineId: Long = 0,
    val pipelineStatus: String = "",
    val updatedAt: Instant,
)
