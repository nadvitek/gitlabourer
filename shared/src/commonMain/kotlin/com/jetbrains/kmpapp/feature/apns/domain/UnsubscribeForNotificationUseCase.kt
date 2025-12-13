package com.jetbrains.kmpapp.feature.apns.domain

import com.jetbrains.kmpapp.core.network.data.ApiLocalDataSource
import com.jetbrains.kmpapp.core.network.data.UnsubscribeRequest
import com.jetbrains.kmpapp.feature.apns.data.NotificationsLocalDataSource
import com.jetbrains.kmpapp.feature.notification.domain.BackendRepository
import com.jetbrains.kmpapp.feature.user.data.UserLocalDataSource

public interface UnsubscribeForNotificationUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(): Boolean
}

internal class UnsubscribeForNotificationUseCaseImpl(
    private val apiLocalDataSource: ApiLocalDataSource,
    private val userLocalDataSource: UserLocalDataSource,
    private val notificationsLocalDataSource: NotificationsLocalDataSource,
    private val backendRepository: BackendRepository
) : UnsubscribeForNotificationUseCase {

    override suspend fun invoke(): Boolean {
        val url = apiLocalDataSource.getUrl()
        val userId = userLocalDataSource.getUserId()

        if (url != null && userId != null) {
            val result = backendRepository.unsubscribe(
                UnsubscribeRequest(
                    userId = userId.id,
                    baseUrl = "https://$url/api/v4/",
                )
            )

            if (result) {
                notificationsLocalDataSource.saveSettings(false)
            }

            return result
        }

        return false
    }
}
