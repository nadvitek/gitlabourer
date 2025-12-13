package com.jetbrains.kmpapp.core.network.data

import kotlinx.serialization.Serializable

@Serializable
public data class UnsubscribeRequest(
    val userId: String,
    val baseUrl: String,
)
