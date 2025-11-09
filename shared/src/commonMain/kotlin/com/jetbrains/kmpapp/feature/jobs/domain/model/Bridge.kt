package com.jetbrains.kmpapp.feature.jobs.domain.model

import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.PipelineStatus

internal data class Bridge(
    val id: Long,
    val status: PipelineStatus,
    val stage: String? = null,
    val name: String? = null,
    val downstreamPipeline: DownstreamPipelineRef? = null
)

internal data class DownstreamPipelineRef(
    val id: Long?,
    val projectId: Long? = null
)
