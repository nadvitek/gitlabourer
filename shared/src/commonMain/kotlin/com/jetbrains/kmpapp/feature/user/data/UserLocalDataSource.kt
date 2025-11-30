package com.jetbrains.kmpapp.feature.user.data

import com.jetbrains.kmpapp.feature.user.domain.model.UserId

internal interface UserLocalDataSource {

    suspend fun saveUserId(id: UserId)
    suspend fun getUserId(): UserId?
    suspend fun clearUserId()
}
