import com.jetbrains.kmpapp.feature.token.data.TokenLocalDataSource
import com.jetbrains.kmpapp.feature.token.domain.model.AuthTokens
import com.russhwolf.settings.coroutines.toFlowSettings
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import com.jetbrains.kmpapp.core.settings.ObservableSettingsFactory
import com.jetbrains.kmpapp.core.settings.SettingsName
import com.russhwolf.settings.ExperimentalSettingsApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO
import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi

internal class TokenSettingsDataSource(
    observableSettingsFactory: ObservableSettingsFactory,
) : TokenLocalDataSource {

    @OptIn(ExperimentalSettingsApi::class)
    private val settings = observableSettingsFactory.create(SettingsName.TOKEN)
        .toFlowSettings(dispatcher = Dispatchers.IO)

    override suspend fun extractToken(): String? {
        return getTokens()?.access?.let { extractTokenFromBase64(it) }
    }

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun saveTokens(tokens: AuthTokens) {
        settings.putString(ACCESS_TOKEN_KEY, tokens.access)
    }

    @OptIn(ExperimentalSettingsApi::class)
    override suspend fun getTokens(): AuthTokens? {
        return settings.getStringOrNull(ACCESS_TOKEN_KEY)?.let { accessToken ->
            AuthTokens(access = accessToken)
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

        private const val ACCESS_TOKEN_KEY = "ACCESS_TOKEN_KEY"
    }
}
