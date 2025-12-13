package com.jetbrains.kmpapp.feature.apns.domain

import com.jetbrains.kmpapp.core.network.data.ApiLocalDataSource
import com.jetbrains.kmpapp.core.network.data.SubscribeRequest
import com.jetbrains.kmpapp.feature.apns.data.ApnsLocalDataSource
import com.jetbrains.kmpapp.feature.apns.data.NotificationsLocalDataSource
import com.jetbrains.kmpapp.feature.notification.domain.BackendRepository
import com.jetbrains.kmpapp.feature.token.data.TokenLocalDataSource
import com.jetbrains.kmpapp.feature.user.data.UserLocalDataSource

public interface SubscribeForNotificationUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(): Boolean
}

internal class SubscribeForNotificationUseCaseImpl(
    private val tokenLocalDataSource: TokenLocalDataSource,
    private val apiLocalDataSource: ApiLocalDataSource,
    private val userLocalDataSource: UserLocalDataSource,
    private val apnsLocalDataSource: ApnsLocalDataSource,
    private val notificationsLocalDataSource: NotificationsLocalDataSource,
    private val backendRepository: BackendRepository
) : SubscribeForNotificationUseCase {

    override suspend fun invoke(): Boolean {
        val url = apiLocalDataSource.getUrl()
        val userId = userLocalDataSource.getUserId()
        val token = tokenLocalDataSource.getTokens()

        val deviceToken = apnsLocalDataSource.getToken()
        if (deviceToken != null && url != null && userId != null && token != null) {
            val result = backendRepository.subscribe(
                SubscribeRequest(
                    userId = userId.id,
                    baseUrl = "https://$url/api/v4/",
                    token = token.privateToken,
                    apnsDeviceToken = deviceToken
                )
            )
            if (result) {
                notificationsLocalDataSource.saveSettings(true)
            }

            return result
        }

        return false
    }
}
