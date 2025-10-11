package com.jetbrains.kmpapp.core.settings

import com.russhwolf.settings.ObservableSettings

internal interface ObservableSettingsFactory {

    fun create(name: SettingsName): ObservableSettings
}
