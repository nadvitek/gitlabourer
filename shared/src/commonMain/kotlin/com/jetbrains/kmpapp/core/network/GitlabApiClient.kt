package com.jetbrains.kmpapp.core.network

import io.ktor.client.HttpClient
import io.ktor.client.call.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.plugins.*
import io.ktor.client.plugins.logging.LogLevel
import io.ktor.client.plugins.logging.Logger
import io.ktor.client.plugins.logging.Logging
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.json.Json

class GitlabApiClient(
    apiAttributes: ApiAttributes,
) {
    val httpClient: HttpClient

    init {
        httpClient = HttpClient {
            install(ContentNegotiation) {
                json(Json {
                    prettyPrint = true
                    ignoreUnknownKeys = true
                })
            }

            install(Logging) {
                logger = object : Logger {
                    override fun log(message: String) {
                        println(message)
                    }
                }
                level = LogLevel.ALL // Log everything (headers, body, etc.)
            }

            defaultRequest {
                url {
                    takeFrom(apiAttributes.baseUrl + "/api/v4/") // Ensures correct base URL handling
                }
                header("PRIVATE-TOKEN", apiAttributes.token)
                contentType(ContentType.Application.Json)
                accept(ContentType.Application.Json)
            }
        }
    }

    suspend inline fun <reified T> get(endpoint: String): T {
        return httpClient.get(endpoint).body()
    }

    suspend inline fun <reified T, reified R> post(endpoint: String, body: R): T {
        return httpClient.post(endpoint) {
            setBody(body)
        }.body()
    }

    fun close() {
        httpClient.close()
    }
}