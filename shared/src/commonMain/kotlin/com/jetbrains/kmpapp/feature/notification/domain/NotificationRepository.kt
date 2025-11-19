package com.jetbrains.kmpapp.feature.notification.domain

import com.jetbrains.kmpapp.feature.notification.domain.model.PipelineUpdate
import kotlinx.coroutines.flow.Flow

internal interface NotificationRepository {
    fun observePipelineUpdates(userId: String): Flow<List<PipelineUpdate>>
}
