package com.jetbrains.kmpapp.feature.jobs.data.api.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class ApiBridge(
    @SerialName("id")
    val id: Long,
    @SerialName("status")
    val status: String,
    @SerialName("stage")
    val stage: String? = null,
    @SerialName("name")
    val name: String? = null,
    @SerialName("downstream_pipeline")
    val downstreamPipeline: ApiDownstreamPipelineRef? = null
)

@Serializable
internal data class ApiDownstreamPipelineRef(
    @SerialName("id")
    val id: Long?,
    @SerialName("project_id")
    val projectId: Long? = null
)
