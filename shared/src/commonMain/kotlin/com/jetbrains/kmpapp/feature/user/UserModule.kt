package com.jetbrains.kmpapp.feature.user

import com.jetbrains.kmpapp.feature.user.data.UserLocalDataSource
import com.jetbrains.kmpapp.feature.user.data.UserSettingsDataSource
import org.koin.dsl.module

internal val userModule = module {
    single<UserLocalDataSource> {
        UserSettingsDataSource(
            observableSettingsFactory = get()
        )
    }
}
