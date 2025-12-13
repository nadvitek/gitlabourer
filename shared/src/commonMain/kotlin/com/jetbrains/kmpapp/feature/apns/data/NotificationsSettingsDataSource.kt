package com.jetbrains.kmpapp.feature.apns.data

import com.jetbrains.kmpapp.core.settings.ObservableSettingsFactory
import com.jetbrains.kmpapp.core.settings.SettingsName
import com.russhwolf.settings.ExperimentalSettingsApi
import com.russhwolf.settings.coroutines.toFlowSettings
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO

internal class NotificationsSettingsDataSource(
    observableSettingsFactory: ObservableSettingsFactory,
) : NotificationsLocalDataSource {

    @OptIn(ExperimentalSettingsApi::class)
    private val settings = observableSettingsFactory.create(SettingsName.NOTIFICATIONS)
        .toFlowSettings(dispatcher = Dispatchers.IO)

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun saveSettings(isNotificationOn: Boolean) {
        settings.putBoolean(NOTIFICATIONS_KEY, isNotificationOn)
    }

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun getSettings(): Boolean {
        return settings.getBoolean(NOTIFICATIONS_KEY, false)
    }

    companion object {

        private const val NOTIFICATIONS_KEY = "NOTIFICATIONS_KEY"
    }
}
