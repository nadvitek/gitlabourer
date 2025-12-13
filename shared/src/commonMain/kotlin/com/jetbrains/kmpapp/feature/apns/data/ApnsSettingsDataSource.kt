package com.jetbrains.kmpapp.feature.apns.data

import com.jetbrains.kmpapp.core.settings.ObservableSettingsFactory
import com.jetbrains.kmpapp.core.settings.SettingsName
import com.russhwolf.settings.ExperimentalSettingsApi
import com.russhwolf.settings.coroutines.toFlowSettings
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO

internal class ApnsSettingsDataSource(
    observableSettingsFactory: ObservableSettingsFactory,
) : ApnsLocalDataSource {

    @OptIn(ExperimentalSettingsApi::class)
    private val settings = observableSettingsFactory.create(SettingsName.DEVICE_TOKEN)
        .toFlowSettings(dispatcher = Dispatchers.IO)

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun saveToken(deviceToken: String) {
        settings.putString(DEVICE_TOKEN_KEY, deviceToken)
    }

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun getToken(): String? {
        return settings.getStringOrNull(DEVICE_TOKEN_KEY)
    }

    companion object {

        private const val DEVICE_TOKEN_KEY = "DEVICE_TOKEN_KEY"
    }
}
