package com.jetbrains.kmpapp.core.network.data

internal interface ApiLocalDataSource {

    suspend fun saveUrl(url: String)
    suspend fun getUrl(): String?
    suspend fun clear()
}
