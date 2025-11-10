package com.jetbrains.kmpapp.core.network

import com.jetbrains.kmpapp.core.network.data.ApiLocalDataSource
import com.jetbrains.kmpapp.feature.token.data.TokenLocalDataSource
import io.ktor.client.HttpClient
import io.ktor.client.HttpClientConfig
import io.ktor.client.call.body
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.plugins.logging.LogLevel
import io.ktor.client.plugins.logging.Logger
import io.ktor.client.plugins.logging.Logging
import io.ktor.client.plugins.defaultRequest
import io.ktor.client.plugins.api.Send
import io.ktor.client.plugins.api.createClientPlugin
import io.ktor.client.request.accept
import io.ktor.client.request.get
import io.ktor.client.request.headers
import io.ktor.client.request.post
import io.ktor.client.request.setBody
import io.ktor.client.statement.HttpResponse
import io.ktor.client.statement.bodyAsText
import io.ktor.http.ContentType
import io.ktor.http.HttpHeaders
import io.ktor.http.URLBuilder
import io.ktor.http.append
import io.ktor.http.appendPathSegments
import io.ktor.http.contentType
import io.ktor.http.encodedPath
import io.ktor.http.takeFrom
import io.ktor.serialization.kotlinx.json.json
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import kotlinx.serialization.json.Json

internal class GitlabApiClient(
    private val tokenLocalDataSource: TokenLocalDataSource,
    private val apiLocalDataSource: ApiLocalDataSource
) {
    internal val httpClient: HttpClient

    init {
        httpClient = HttpClient {
            install(ContentNegotiation) {
                json(
                    Json {
                        prettyPrint = true
                        ignoreUnknownKeys = true
                    }
                )
            }

            install(Logging) {
                logger = object : Logger {
                    override fun log(message: String) = println(message)
                }
                level = LogLevel.ALL
            }

            setUpDefaultRequest()

            install(PrivateTokenPlugin.Plugin) {
                tokenProvider = { tokenLocalDataSource.extractToken() }
                requireToken = true
            }
        }
    }

    private fun HttpClientConfig<*>.setUpDefaultRequest() {
        defaultRequest {
            contentType(ContentType.Application.Json)
            accept(ContentType.Application.Json)
            // There's no way to make this suspend because ktor doesn't support it. However, this
            // is always called on Dispatchers.IO, so it only briefly blocks a worker thread.
            runBlocking {
                val apiUrl = apiLocalDataSource
                    .getUrl()

                url("https://$apiUrl/api/v4/")
            }
        }
    }

    suspend inline fun <reified T> get(endpoint: String): T =
        httpClient.get(endpoint).body()

    suspend inline fun <reified T, reified R> post(endpoint: String, body: R): T =
        httpClient.post(endpoint) { setBody(body) }.body()

    suspend inline fun <reified T> post(endpoint: String): T =
        httpClient.post(endpoint).body()

    suspend fun getRaw(
        endpoint: String,
        accept: ContentType = ContentType.Any
    ): HttpResponse {
        return httpClient.get(endpoint) {
            accept(accept)
        }
    }

    suspend fun getText(endpoint: String): String =
        httpClient.get(endpoint) {
            headers {
                append(HttpHeaders.Accept, ContentType.Text.Plain)
            }
        }.bodyAsText()

    fun close() = httpClient.close()

    private fun normalizeBaseUrl(raw: String?): String {
        val trimmed = raw?.trim().orEmpty()
        if (trimmed.isBlank()) return "https://gitlab.com"

        val withScheme =
            if (trimmed.startsWith("http://", ignoreCase = true) ||
                trimmed.startsWith("https://", ignoreCase = true)
            ) trimmed
            else "https://$trimmed"

        return withScheme.trimEnd('/')
    }
}

internal object PrivateTokenPlugin {
    class Config {
        var headerName: String = "PRIVATE-TOKEN"
        var requireToken: Boolean = true
        lateinit var tokenProvider: suspend () -> String?
    }

    val Plugin = createClientPlugin("PrivateTokenPlugin", ::Config) {
        val header = pluginConfig.headerName
        val provider = pluginConfig.tokenProvider
        val mustHave = pluginConfig.requireToken

        on(Send) { request ->
            val token = provider()
            request.headers.remove(header)
            when {
                token.isNullOrBlank() && mustHave ->
                    throw IllegalStateException("Missing $header")
                !token.isNullOrBlank() ->
                    request.headers.append(header, token)
            }
            proceed(request)
        }
    }
}

internal object DynamicBaseUrlPlugin {
    class Config {
        lateinit var baseUrlProvider: suspend () -> String?
        var apiPath: List<String> = listOf("api", "v4")
        var onlyForRelativeRequests: Boolean = true
    }

    val Plugin = createClientPlugin("DynamicBaseUrlPlugin", ::Config) {
        val provider = pluginConfig.baseUrlProvider
        val apiPath = pluginConfig.apiPath
        val onlyRelative = pluginConfig.onlyForRelativeRequests

        on(Send) { request ->
            val isRelative = request.url.host.isEmpty()

            if (onlyRelative && !isRelative) {
                return@on proceed(request)
            }

            val base = provider()?.trimEnd('/')
                ?: throw IllegalStateException("Missing base URL")

            val parsed = URLBuilder().apply { takeFrom(base) }.build()
            require(parsed.host.isNotBlank()) { "Base URL must include a host (got '$base')" }

            val apiBase = URLBuilder().apply {
                takeFrom(base)
                appendPathSegments(apiPath)
            }.build()

            val originalPath = request.url.encodedPath
            val originalQuery = request.url.build().encodedQuery

            request.url.takeFrom(apiBase)

            val joinedPath = listOf(
                request.url.encodedPath.trimEnd('/'),
                originalPath.trimStart('/')
            ).filter { it.isNotEmpty() }.joinToString("/")

            request.url.encodedPath = if (joinedPath.isEmpty()) "/" else "/$joinedPath"

            if (originalQuery.isNotBlank()) {
                request.url.parameters.clear()

                val parsed = URLBuilder("https://dummy.invalid/?$originalQuery").build().parameters
                parsed.names().forEach { name ->
                    parsed.getAll(name)?.forEach { value ->
                        request.url.parameters.append(name, value)
                    }
                }
            }

            return@on proceed(request)
        }
    }
}
