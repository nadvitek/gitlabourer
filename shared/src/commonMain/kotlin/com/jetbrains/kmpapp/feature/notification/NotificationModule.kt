package com.jetbrains.kmpapp.feature.notification

import com.jetbrains.kmpapp.feature.notification.domain.NotificationRepository
import com.jetbrains.kmpapp.feature.notification.domain.usecase.ObservePipelineUpdatesUseCase
import com.jetbrains.kmpapp.feature.notification.domain.usecase.ObservePipelineUpdatesUseCaseImpl
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO
import org.koin.dsl.module

internal val notificationModule = module {
//    single<NotificationRepository> {
//        NotificationRepositoryImpl()
//    }
//    factory<ObservePipelineUpdatesUseCase> {
//        ObservePipelineUpdatesUseCaseImpl(
//            repository = get(),
//            ioDispatcher = Dispatchers.IO
//        )
//    }
}
