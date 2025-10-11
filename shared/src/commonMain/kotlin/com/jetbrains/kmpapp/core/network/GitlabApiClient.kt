package com.jetbrains.kmpapp.core.network

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
import io.ktor.client.request.post
import io.ktor.client.request.setBody
import io.ktor.http.ContentType
import io.ktor.http.URLBuilder
import io.ktor.http.appendPathSegments
import io.ktor.http.contentType
import io.ktor.http.takeFrom
import io.ktor.serialization.kotlinx.json.json
import kotlinx.serialization.json.Json

internal class GitlabApiClient(
    private val apiAttributes: ApiAttributes,
    private val tokenLocalDataSource: TokenLocalDataSource,
) {
    internal val httpClient: HttpClient

    init {
        val apiBase = URLBuilder().apply {
            takeFrom(apiAttributes.baseUrl)
            appendPathSegments("api", "v4")
        }.buildString()

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
                url { takeFrom("$apiBase/") }
                contentType(ContentType.Application.Json)
                accept(ContentType.Application.Json)
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
