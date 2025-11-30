package com.jetbrains.kmpapp.feature.user.data

import com.jetbrains.kmpapp.core.settings.ObservableSettingsFactory
import com.jetbrains.kmpapp.core.settings.SettingsName
import com.jetbrains.kmpapp.feature.user.domain.model.UserId
import com.russhwolf.settings.ExperimentalSettingsApi
import com.russhwolf.settings.coroutines.toFlowSettings
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO

internal class UserSettingsDataSource(
    observableSettingsFactory: ObservableSettingsFactory,
) : UserLocalDataSource {

    @OptIn(ExperimentalSettingsApi::class)
    private val settings = observableSettingsFactory.create(SettingsName.USER_ID)
        .toFlowSettings(dispatcher = Dispatchers.IO)

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun saveUserId(id: UserId) {
        settings.putString(USER_ID, id.id)
    }

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun getUserId(): UserId? {
        return settings.getStringOrNull(USER_ID)?.let { userId ->
            UserId(userId)
        }
    }

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun clearUserId() {
        settings.clear()
    }

    companion object {

        private const val USER_ID = "USER_ID"
    }
}
