package com.jetbrains.kmpapp.feature.pipelines.data.api.mapper

import com.jetbrains.kmpapp.feature.login.data.api.mapper.ApiUserMapper
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.PipelineStatus
import com.jetbrains.kmpapp.feature.pipelines.data.api.model.ApiDetailedPipeline
import com.jetbrains.kmpapp.feature.pipelines.domain.model.DetailedPipeline

internal class ApiDetailedPipelineMapper {

    private val apiUserMapper = ApiUserMapper()

    fun map(api: ApiDetailedPipeline): DetailedPipeline = DetailedPipeline(
        id = api.id,
        iid = api.iid,
        name = null,
        projectId = api.projectId,
        status = PipelineStatus.from(api.status),
        ref = api.ref,
        sha = api.sha,
        webUrl = api.webUrl,
        user = api.user?.let(apiUserMapper::map),
        createdAt = api.createdAt,
        updatedAt = api.updatedAt,
        startedAt = api.startedAt,
        finishedAt = api.finishedAt,
        durationSeconds = api.duration,
        queuedDurationSeconds = api.queuedDuration,
        coverage = api.coverage,
        source = api.source
    )
}
