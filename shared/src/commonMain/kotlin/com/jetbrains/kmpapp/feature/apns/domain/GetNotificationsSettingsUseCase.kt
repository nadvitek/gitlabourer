package com.jetbrains.kmpapp.feature.apns.domain

import com.jetbrains.kmpapp.core.network.data.ApiLocalDataSource
import com.jetbrains.kmpapp.core.network.data.UnsubscribeRequest
import com.jetbrains.kmpapp.feature.apns.data.NotificationsLocalDataSource
import com.jetbrains.kmpapp.feature.notification.domain.BackendRepository
import com.jetbrains.kmpapp.feature.user.data.UserLocalDataSource

public interface GetNotificationsSettingsUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(): Boolean
}

internal class GetNotificationsSettingsUseCaseImpl(
    private val notificationsSettingsLocalDataSource: NotificationsLocalDataSource
) : GetNotificationsSettingsUseCase {

    override suspend fun invoke(): Boolean {
        return notificationsSettingsLocalDataSource.getSettings()
    }
}
