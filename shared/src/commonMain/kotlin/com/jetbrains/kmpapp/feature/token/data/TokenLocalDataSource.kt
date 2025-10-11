package com.jetbrains.kmpapp.feature.token.data

import com.jetbrains.kmpapp.feature.token.domain.model.AuthTokens

internal interface TokenLocalDataSource {

    suspend fun extractToken(): String?
    suspend fun saveTokens(tokens: AuthTokens)
    suspend fun getTokens(): AuthTokens?
    suspend fun clear()
}
