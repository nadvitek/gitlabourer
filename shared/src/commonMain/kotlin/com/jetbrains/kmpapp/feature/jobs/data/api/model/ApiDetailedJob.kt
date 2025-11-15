package com.jetbrains.kmpapp.feature.jobs.data.api.model

import com.jetbrains.kmpapp.feature.login.data.api.model.ApiUser
import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable
import kotlinx.serialization.SerialName

@Serializable
internal data class ApiJobSummary(
    @SerialName("id")
    val id: Long,
    @SerialName("status")
    val status: String? = null,
    @SerialName("stage")
    val stage: String? = null,
    @SerialName("name")
    val name: String? = null,
    @SerialName("ref")
    val ref: String? = null,
    @SerialName("user")
    val user: ApiUser? = null,
    @SerialName("created_at")
    val createdAt: Instant? = null,
    @SerialName("started_at")
    val startedAt: Instant? = null,
    @SerialName("finished_at")
    val finishedAt: Instant? = null,
    @SerialName("duration")
    val duration: Double? = null,
    @SerialName("web_url")
    val webUrl: String? = null,
    @SerialName("pipeline")
    val pipeline: ApiJobPipelineRef? = null,
    @SerialName("commit")
    val commit: ApiJobCommitRef? = null
)

@Serializable
internal data class ApiDetailedJob(
    @SerialName("id")
    val id: Long,
    @SerialName("status")
    val status: String,
    @SerialName("stage")
    val stage: String? = null,
    @SerialName("name")
    val name: String? = null,
    @SerialName("ref")
    val ref: String? = null,
    @SerialName("web_url")
    val webUrl: String? = null,
    @SerialName("user")
    val user: ApiUser? = null,
    @SerialName("created_at")
    val createdAt: Instant? = null,
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
    @SerialName("pipeline")
    val pipeline: ApiJobPipelineRef? = null,
    @SerialName("commit")
    val commit: ApiJobCommitRef? = null
)

@Serializable
internal data class ApiJobPipelineRef(
    @SerialName("id") val id: Long
)

@Serializable
internal data class ApiJobCommitRef(
    @SerialName("id")
    val id: String? = null,
    @SerialName("title")
    val title: String? = null,
    @SerialName("sha")
    val sha: String? = null
)
