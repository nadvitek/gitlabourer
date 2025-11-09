package com.jetbrains.kmpapp.core.network

import com.jetbrains.kmpapp.core.network.data.ApiLocalDataSource
import com.jetbrains.kmpapp.feature.token.data.TokenLocalDataSource
import io.ktor.client.HttpClient
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
import io.ktor.http.takeFrom
import io.ktor.serialization.kotlinx.json.json
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

            defaultRequest {
                contentType(ContentType.Application.Json)
                accept(ContentType.Application.Json)
            }

            install(DynamicBaseUrlPlugin.Plugin) {
                baseUrlProvider = {
                    apiLocalDataSource.getUrl()
                        ?: "https://gitlab.com"
                }
                apiPath = listOf("api", "v4")
                onlyForRelativeRequests = true
            }

            install(PrivateTokenPlugin.Plugin) {
                tokenProvider = { tokenLocalDataSource.extractToken() }
                requireToken = true
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
        // Provide the server root, e.g. "https://gitlab.example.com"
        lateinit var baseUrlProvider: suspend () -> String?
        // Path pieces appended after the base (defaults to /api/v4)
        var apiPath: List<String> = listOf("api", "v4")
        // If true, only rewrite URLs that are *relative* (recommended)
        var onlyForRelativeRequests: Boolean = true
    }

    val Plugin = createClientPlugin("DynamicBaseUrlPlugin", ::Config) {
        val provider = pluginConfig.baseUrlProvider
        val apiPath = pluginConfig.apiPath
        val onlyRelative = pluginConfig.onlyForRelativeRequests

        on(Send) { request ->
            val isRelative = request.url.host.isNullOrEmpty()
            if (onlyRelative && !isRelative) {
                proceed(request); return@on
            }

            val base = provider()?.trimEnd('/')
                ?: throw IllegalStateException("Missing base URL")

            val apiBase = URLBuilder().apply {
                takeFrom(base)
                appendPathSegments(apiPath)
            }.build()

            // Keep the original (possibly relative) path & query
            val originalPath = request.url.encodedPath
            val originalQuery = request.url.build().encodedQuery

            // Prefix with {base}/api/v4
            request.url.takeFrom(apiBase)

            // Re-attach original path and query (without duplicating slashes)
            val joinedPath = listOf(request.url.encodedPath.trimEnd('/'),
                originalPath.trimStart('/'))
                .filter { it.isNotEmpty() }
                .joinToString("/")

            request.url.encodedPath = if (joinedPath.isEmpty()) "/" else "/$joinedPath"
            if (!originalQuery.isNullOrBlank()) {
                request.url.parameters.clear()
                URLBuilder("https://dummy.invalid/?$originalQuery").parameters.forEach {
                        key, values -> values.forEach { v -> request.url.parameters.append(key, v) }
                }
            }

            proceed(request)
        }
    }
}
