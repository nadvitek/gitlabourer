package com.jetbrains.kmpapp.feature.login.domain

import com.jetbrains.kmpapp.feature.login.domain.model.User

internal interface LoginRepository {
    suspend fun login(token: String): User?
}
