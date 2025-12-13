package com.jetbrains.kmpapp.feature.notification.data

import com.jetbrains.kmpapp.core.network.HttpClientProvider
import com.jetbrains.kmpapp.core.network.data.SubscribeRequest
import com.jetbrains.kmpapp.core.network.data.UnsubscribeRequest
import com.jetbrains.kmpapp.feature.notification.domain.BackendRepository
import io.ktor.client.request.post
import io.ktor.client.request.setBody
import io.ktor.http.ContentType
import io.ktor.http.contentType

internal class BackendRepositoryImpl(): BackendRepository {

    private val httpClient = HttpClientProvider.client

    override suspend fun subscribe(request: SubscribeRequest): Boolean {
        try {
            httpClient.post("https://vapor-service-751228020136.europe-central2.run.app/subscribe") {
                contentType(ContentType.Application.Json)
                setBody(request)
            }

            return true
        } catch (e: Throwable) {
            print(e)
            return false
        }
    }

    override suspend fun unsubscribe(request: UnsubscribeRequest): Boolean {
        try {
            httpClient.post("https://vapor-service-751228020136.europe-central2.run.app/unsubscribe") {
                contentType(ContentType.Application.Json)
                setBody(request)
            }

            return true
        } catch (e: Throwable) {
            print(e)
            return false
        }
    }
}
