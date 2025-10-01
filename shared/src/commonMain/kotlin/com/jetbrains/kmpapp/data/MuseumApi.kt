package com.jetbrains.kmpapp.data

import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.request.get
import kotlin.coroutines.cancellation.CancellationException

interface GitlabApi {
    suspend fun getRepositories(): List<MuseumObject>
}

class KtorGitlabApi(private val client: HttpClient) : GitlabApi {
    companion object {
        private const val API_URL = "https://gitlab.ack.ee/api/v4/"
        private const val GROUPS_EP = "/groups"
        private const val USER_PROJECTS_EP = "/users/442/projects"
        private const val PROJECTS_EP = "/projects"
        private const val PRIVATE_TOKEN = ""
    }

    override suspend fun getRepositories(): List<MuseumObject> {
        return try {
            client.get(API_URL).body()
        } catch (e: Exception) {
            if (e is CancellationException) throw e
            e.printStackTrace()

            emptyList()
        }
    }
}
