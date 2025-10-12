package com.jetbrains.kmpapp.feature.login.data

import com.jetbrains.kmpapp.feature.login.domain.model.User

internal interface LoginRemoteDataSource {

    suspend fun login(token: String) : User?

    companion object Endpoints {
        const val USER = "user"
    }
}
