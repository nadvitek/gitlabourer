package com.jetbrains.kmpapp.core.settings

/**
 * Name of KMP Settings file used to store simple settings values
 */
internal enum class SettingsName(val settingsFileName: String) {

    TOKEN("token"),
    URL("url")
}
