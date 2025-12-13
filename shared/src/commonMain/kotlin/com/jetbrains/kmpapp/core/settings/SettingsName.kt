package com.jetbrains.kmpapp.core.settings

/**
 * Name of KMP Settings file used to store simple settings values
 */
internal enum class SettingsName(val settingsFileName: String) {

    DEVICE_TOKEN("device_token"),
    NOTIFICATIONS("notifications"),
    TOKEN("token"),
    URL("url"),
    USER_ID("userId")
}
