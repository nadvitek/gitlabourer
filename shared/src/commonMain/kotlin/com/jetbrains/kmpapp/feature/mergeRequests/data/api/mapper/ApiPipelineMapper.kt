package com.jetbrains.kmpapp.feature.mergeRequests.data.api.mapper

import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiPipeline
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.Pipeline
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.PipelineStatus

internal class ApiPipelineMapper {
    fun map(api: ApiPipeline): Pipeline = Pipeline(
        id = api.id.toString(),
        sha = api.sha,
        ref = api.ref,
        status = PipelineStatus.from(api.status)
    )
}
