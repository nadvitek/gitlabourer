package com.jetbrains.kmpapp.feature.apns

import com.jetbrains.kmpapp.feature.apns.data.ApnsLocalDataSource
import com.jetbrains.kmpapp.feature.apns.data.ApnsSettingsDataSource
import com.jetbrains.kmpapp.feature.apns.data.NotificationsLocalDataSource
import com.jetbrains.kmpapp.feature.apns.data.NotificationsSettingsDataSource
import com.jetbrains.kmpapp.feature.apns.domain.GetNotificationsSettingsUseCase
import com.jetbrains.kmpapp.feature.apns.domain.GetNotificationsSettingsUseCaseImpl
import com.jetbrains.kmpapp.feature.apns.domain.SubscribeForNotificationUseCase
import com.jetbrains.kmpapp.feature.apns.domain.SubscribeForNotificationUseCaseImpl
import com.jetbrains.kmpapp.feature.apns.domain.UnsubscribeForNotificationUseCase
import com.jetbrains.kmpapp.feature.apns.domain.UnsubscribeForNotificationUseCaseImpl
import com.jetbrains.kmpapp.feature.notification.data.BackendRepositoryImpl
import com.jetbrains.kmpapp.feature.notification.domain.BackendRepository
import com.jetbrains.kmpapp.feature.token.domain.SaveDeviceTokenUseCase
import com.jetbrains.kmpapp.feature.token.domain.SaveDeviceTokenUseCaseImpl
import org.koin.dsl.module

internal val apnsModule = module {
    single<ApnsLocalDataSource> {
        ApnsSettingsDataSource(
            observableSettingsFactory = get()
        )
    }
    single<NotificationsLocalDataSource> {
        NotificationsSettingsDataSource(
            observableSettingsFactory = get()
        )
    }
    single<BackendRepository> {
        BackendRepositoryImpl()
    }

    factory<SaveDeviceTokenUseCase> {
        SaveDeviceTokenUseCaseImpl(
            apnsLocalDataSource = get()
        )
    }

    factory<SubscribeForNotificationUseCase> {
        SubscribeForNotificationUseCaseImpl(
            tokenLocalDataSource = get(),
            apiLocalDataSource = get(),
            userLocalDataSource = get(),
            apnsLocalDataSource = get(),
            notificationsLocalDataSource = get(),
            backendRepository = get()
        )
    }

    factory<UnsubscribeForNotificationUseCase> {
        UnsubscribeForNotificationUseCaseImpl(
            apiLocalDataSource = get(),
            userLocalDataSource = get(),
            notificationsLocalDataSource = get(),
            backendRepository = get()
        )
    }

    factory<GetNotificationsSettingsUseCase> {
        GetNotificationsSettingsUseCaseImpl(
            notificationsSettingsLocalDataSource = get(),
        )
    }
}
