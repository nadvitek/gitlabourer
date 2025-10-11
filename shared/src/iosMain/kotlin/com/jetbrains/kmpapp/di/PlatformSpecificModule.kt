package com.jetbrains.kmpapp.di

import com.jetbrains.kmpapp.ObservableSettingsFactoryIos
import com.jetbrains.kmpapp.core.settings.ObservableSettingsFactory
import org.koin.core.module.Module
import org.koin.dsl.module

internal actual val platformSpecificModule: Module = module {
    single<ObservableSettingsFactory> { ObservableSettingsFactoryIos() }
}
