package com.jetbrains.kmpapp.core.network.data

import kotlinx.serialization.Serializable

@Serializable
public data class SubscribeRequest(
    val userId: String,
    val baseUrl: String,
    val token: String,
    val apnsDeviceToken: String
)
