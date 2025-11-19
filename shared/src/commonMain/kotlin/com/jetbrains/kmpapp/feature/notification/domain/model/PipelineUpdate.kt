package com.jetbrains.kmpapp.feature.notification.domain.model

import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.PipelineStatus
import kotlinx.datetime.Instant

public data class PipelineUpdate(
    val userId: String,
    val projectId: Int,
    val mrIid: Int,
    val mrTitle: String,
    val pipelineId: Int,
    val status: PipelineStatus,
    val updatedAt: Instant,
)
