package com.jetbrains.kmpapp.feature.notification.data.api.mapper

import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.PipelineStatus
import com.jetbrains.kmpapp.feature.notification.data.api.model.FirebasePipelineStatus
import com.jetbrains.kmpapp.feature.notification.domain.model.PipelineUpdate

internal class FirebasePipelineStatusMapper {

    fun map(api: FirebasePipelineStatus): PipelineUpdate =
        PipelineUpdate(
            userId = api.userId,
            projectId = api.projectId.toInt(),
            mrIid = api.mrIid.toInt(),
            mrTitle = api.mrTitle,
            pipelineId = api.pipelineId.toInt(),
            status = PipelineStatus.fromBackend(api.pipelineStatus),
            updatedAt = api.updatedAt
        )
}
