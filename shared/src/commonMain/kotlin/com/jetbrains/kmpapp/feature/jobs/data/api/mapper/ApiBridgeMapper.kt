package com.jetbrains.kmpapp.feature.jobs.data.api.mapper

import com.jetbrains.kmpapp.feature.jobs.data.api.model.ApiBridge
import com.jetbrains.kmpapp.feature.jobs.data.api.model.ApiDownstreamPipelineRef
import com.jetbrains.kmpapp.feature.jobs.domain.model.Bridge
import com.jetbrains.kmpapp.feature.jobs.domain.model.DownstreamPipelineRef
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.PipelineStatus

internal class ApiBridgeMapper {

    fun map(api: ApiBridge): Bridge = Bridge(
        id = api.id,
        status = PipelineStatus.from(api.status),
        stage = api.stage,
        name = api.name,
        downstreamPipeline = api.downstreamPipeline?.let(::map)
    )

    private fun map(downstreamPipelineRef: ApiDownstreamPipelineRef): DownstreamPipelineRef = DownstreamPipelineRef(
        id = downstreamPipelineRef.id,
        projectId = downstreamPipelineRef.projectId
    )
}
