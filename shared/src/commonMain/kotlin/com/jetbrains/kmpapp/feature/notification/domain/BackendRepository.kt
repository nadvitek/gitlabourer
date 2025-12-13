package com.jetbrains.kmpapp.feature.notification.domain

import com.jetbrains.kmpapp.core.network.data.SubscribeRequest
import com.jetbrains.kmpapp.core.network.data.UnsubscribeRequest

internal interface BackendRepository {
    suspend fun subscribe(request: SubscribeRequest): Boolean
    suspend fun unsubscribe(request: UnsubscribeRequest): Boolean
}
