package com.jetbrains.kmpapp.feature.pipelines.domain.model

import com.jetbrains.kmpapp.feature.login.domain.model.User
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.PipelineStatus
import kotlinx.datetime.Instant

public data class DetailedPipeline(
    val id: Long,
    val iid: Long?,
    val name: String?,
    val projectId: Long?,
    val status: PipelineStatus,
    val ref: String,
    val sha: String,
    val webUrl: String,
    val user: User?,
    val createdAt: Instant?,
    val updatedAt: Instant?,
    val startedAt: Instant?,
    val finishedAt: Instant?,
    val durationSeconds: Double?,
    val queuedDurationSeconds: Double?,
    val coverage: String?,
    val source: String?
)
