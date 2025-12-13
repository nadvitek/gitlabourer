package com.jetbrains.kmpapp.feature.apns.data

internal interface ApnsLocalDataSource {

    suspend fun saveToken(deviceToken: String)
    suspend fun getToken(): String?
}
