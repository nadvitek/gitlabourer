package com.jetbrains.kmpapp.feature.notification

import com.jetbrains.kmpapp.feature.notification.data.BackendRepositoryImpl
import com.jetbrains.kmpapp.feature.notification.domain.BackendRepository
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
    single<BackendRepository> {
        BackendRepositoryImpl()
    }
}
