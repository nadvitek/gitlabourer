package com.jetbrains.kmpapp.feature.pipelines.data.api.model

import com.jetbrains.kmpapp.feature.login.data.api.model.ApiUser
import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class ApiDetailedPipeline(
    @SerialName("id")
    val id: Long,
    @SerialName("iid")
    val iid: Long? = null,
    @SerialName("project_id")
    val projectId: Long? = null,
    @SerialName("status")
    val status: String,
    @SerialName("ref")
    val ref: String,
    @SerialName("sha")
    val sha: String,
    @SerialName("web_url")
    val webUrl: String,
    @SerialName("user")
    val user: ApiUser?,
    @SerialName("created_at")
    val createdAt: Instant? = null,
    @SerialName("updated_at")
    val updatedAt: Instant? = null,
    @SerialName("started_at")
    val startedAt: Instant? = null,
    @SerialName("finished_at")
    val finishedAt: Instant? = null,
    @SerialName("duration")
    val duration: Double? = null,
    @SerialName("queued_duration")
    val queuedDuration: Double? = null,
    @SerialName("coverage")
    val coverage: String? = null,
    @SerialName("source")
    val source: String? = null
)
