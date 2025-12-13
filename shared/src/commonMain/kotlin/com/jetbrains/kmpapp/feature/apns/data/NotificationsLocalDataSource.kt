package com.jetbrains.kmpapp.feature.apns.data

internal interface NotificationsLocalDataSource {

    suspend fun saveSettings(isNotificationOn: Boolean)
    suspend fun getSettings(): Boolean
}
