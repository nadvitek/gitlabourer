package com.jetbrains.kmpapp.feature.jobs.data.api.mapper

import com.jetbrains.kmpapp.feature.jobs.data.api.model.ApiDetailedJob
import com.jetbrains.kmpapp.feature.jobs.data.api.model.ApiJobSummary
import com.jetbrains.kmpapp.feature.jobs.domain.model.DetailedJob
import com.jetbrains.kmpapp.feature.login.data.api.mapper.ApiUserMapper
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.PipelineStatus

internal class ApiDetailedJobMapper {

    private val apiUserMapper = ApiUserMapper()

    fun map(api: ApiDetailedJob): DetailedJob = DetailedJob(
        id = api.id,
        status = PipelineStatus.from(api.status),
        stage = api.stage,
        name = api.name,
        pipelineName = null,
        ref = api.ref,
        webUrl = api.webUrl,
        user = api.user?.let(apiUserMapper::map),
        createdAt = api.createdAt,
        startedAt = api.startedAt,
        finishedAt = api.finishedAt,
        durationSeconds = api.duration,
    )

    fun map(api: ApiJobSummary): DetailedJob = DetailedJob(
        id = api.id,
        status = PipelineStatus.from(api.status),
        stage = api.stage,
        name = api.name,
        pipelineName = api.commit?.name,
        ref = api.ref,
        webUrl = api.webUrl,
        user = api.user?.let(apiUserMapper::map),
        createdAt = api.createdAt,
        startedAt = api.startedAt,
        finishedAt = api.finishedAt,
        durationSeconds = api.duration,
    )
}
