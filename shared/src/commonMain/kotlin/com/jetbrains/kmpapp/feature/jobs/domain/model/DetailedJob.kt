package com.jetbrains.kmpapp.feature.jobs.domain.model

import com.jetbrains.kmpapp.feature.login.domain.model.User
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.PipelineStatus
import kotlinx.datetime.Instant

public data class DetailedJob(
    val id: Long,
    val status: PipelineStatus,
    val stage: String?,
    val name: String?,
    val pipelineName: String? = null,
    val ref: String? = null,
    val webUrl: String? = null,
    val user: User? = null,
    val createdAt: Instant? = null,
    val startedAt: Instant? = null,
    val finishedAt: Instant? = null,
    val durationSeconds: Double? = null,
)
