package com.jetbrains.kmpapp.core.network.data

import com.jetbrains.kmpapp.core.settings.ObservableSettingsFactory
import com.jetbrains.kmpapp.core.settings.SettingsName
import com.jetbrains.kmpapp.feature.token.domain.model.AuthTokens
import com.russhwolf.settings.ExperimentalSettingsApi
import com.russhwolf.settings.coroutines.toFlowSettings
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi

internal class ApiSettingsDataSource(
    observableSettingsFactory: ObservableSettingsFactory,
) : ApiLocalDataSource {

    @OptIn(ExperimentalSettingsApi::class)
    private val settings = observableSettingsFactory.create(SettingsName.URL)
        .toFlowSettings(dispatcher = Dispatchers.IO)

    override suspend fun extractToken(): String? {
        return getTokens()?.privateToken
    }

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun saveTokens(tokens: AuthTokens) {
        settings.putString(ACCESS_TOKEN_KEY, tokens.privateToken)
    }

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun getTokens(): AuthTokens? {
        return settings.getStringOrNull(ACCESS_TOKEN_KEY)?.let { accessToken ->
            AuthTokens(privateToken = accessToken)
        }
    }

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun clear() {
        settings.clear()
    }

    @OptIn(ExperimentalEncodingApi::class)
    @Suppress("SwallowedException")
    private fun extractTokenFromBase64(input: String): String? {
        return try {
            val bytes = Base64.decode(input)
            val start = bytes.indexOf('{'.code.toByte()).takeIf { it >= 0 } ?: return null
            val jsonText = bytes.copyOfRange(start, bytes.size).decodeToString()
            val json = Json.parseToJsonElement(jsonText).jsonObject
            json["token"]?.jsonPrimitive?.content
        } catch (e: Exception) {
            null
        }
    }

    companion object {

        private const val API_URL = "API_URL"
    }
}
