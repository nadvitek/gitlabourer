package com.jetbrains.kmpapp.feature.jobs.domain.model

public data class JobsStream(
    val pipelineId: Long,
    val projectId: Long,
    val sections: List<JobsSection>,
    val downstreams: List<JobsStream>
)
