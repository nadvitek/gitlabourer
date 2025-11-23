package com.jetbrains.kmpapp.core.network

import com.jetbrains.kmpapp.core.model.api.ApiPagedResponse
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
import io.ktor.http.append
import io.ktor.http.contentType
import io.ktor.serialization.kotlinx.json.json
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

    suspend inline fun <reified T> getPaged(
        endpoint: String
    ): ApiPagedResponse<T> {
        val response = httpClient.get(endpoint)

        val body: T = response.body()

        fun headerInt(name: String): Int? =
            response.headers[name]?.toIntOrNull()

        return ApiPagedResponse(
            response = body,
            currentPage = headerInt("X-Page"),
            nextPage = headerInt("X-Next-Page")?.takeIf { it != 0 },
            totalPages = headerInt("X-Total-Pages"),
            totalItems = headerInt("X-Total"),
            perPage = headerInt("X-Per-Page")
        )
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
