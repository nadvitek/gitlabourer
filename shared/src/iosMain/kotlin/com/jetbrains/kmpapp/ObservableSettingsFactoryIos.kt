package com.jetbrains.kmpapp

import com.jetbrains.kmpapp.core.settings.ObservableSettingsFactory
import com.jetbrains.kmpapp.core.settings.SettingsName
import com.russhwolf.settings.NSUserDefaultsSettings
import com.russhwolf.settings.ObservableSettings

internal class ObservableSettingsFactoryIos : ObservableSettingsFactory {

    private val userDefaultsFactory = NSUserDefaultsSettings.Factory()

    override fun create(name: SettingsName): ObservableSettings {
        return userDefaultsFactory.create(name.settingsFileName)
    }
}
