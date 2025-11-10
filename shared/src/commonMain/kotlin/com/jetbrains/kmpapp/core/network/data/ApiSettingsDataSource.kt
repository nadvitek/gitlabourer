package com.jetbrains.kmpapp.core.network.data

import com.jetbrains.kmpapp.core.settings.ObservableSettingsFactory
import com.jetbrains.kmpapp.core.settings.SettingsName
import com.russhwolf.settings.ExperimentalSettingsApi
import com.russhwolf.settings.coroutines.toFlowSettings
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO

internal class ApiSettingsDataSource(
    observableSettingsFactory: ObservableSettingsFactory,
) : ApiLocalDataSource {

    @OptIn(ExperimentalSettingsApi::class)
    private val settings = observableSettingsFactory.create(SettingsName.URL)
        .toFlowSettings(dispatcher = Dispatchers.IO)

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun saveUrl(url: String) {
        settings.putString(API_URL, url)
    }

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun getUrl(): String? {
        return settings.getStringOrNull(API_URL)
    }

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun clear() {
        settings.clear()
    }

    companion object {

        private const val API_URL = "API_URL"
    }
}
