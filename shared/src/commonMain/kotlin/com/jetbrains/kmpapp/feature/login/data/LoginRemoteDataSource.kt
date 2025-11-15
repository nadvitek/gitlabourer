package com.jetbrains.kmpapp.feature.login.data

import com.jetbrains.kmpapp.feature.login.domain.model.User

internal interface LoginRemoteDataSource {

    suspend fun login() : User?
    suspend fun getUser() : User?

    companion object Endpoints {
        const val USER = "user"
    }
}
