package com.jetbrains.kmpapp.feature.mergeRequests.domain.model

public data class Pipeline(
    val id: String,
    val sha: String,
    val ref: String,
    val status: PipelineStatus
) {
    val isRunning: Boolean get() = status == PipelineStatus.RUNNING
    val isSuccess: Boolean get() = status == PipelineStatus.SUCCESS
    val isFailed: Boolean get() = status == PipelineStatus.FAILED
}

public enum class PipelineStatus {
    CREATED,
    WAITING_FOR_RESOURCE,
    PREPARING,
    PENDING,
    RUNNING,
    SUCCESS,
    FAILED,
    CANCELED,
    SKIPPED,
    MANUAL,
    SCHEDULED,
    UNKNOWN;

    public companion object {
        public fun from(api: String?): PipelineStatus = when (api?.lowercase()) {
            "created" -> CREATED
            "waiting_for_resource" -> WAITING_FOR_RESOURCE
            "preparing" -> PREPARING
            "pending" -> PENDING
            "running" -> RUNNING
            "success" -> SUCCESS
            "failed" -> FAILED
            "canceled" -> CANCELED
            "skipped" -> SKIPPED
            "manual" -> MANUAL
            "scheduled" -> SCHEDULED
            else -> UNKNOWN
        }

        public fun fromBackend(value: String): PipelineStatus =
            entries.firstOrNull { it.name.equals(value, ignoreCase = true) }
                ?: when (value.lowercase()) {
                    "waiting_for_resource" -> WAITING_FOR_RESOURCE
                    else -> UNKNOWN
                }
    }
}
