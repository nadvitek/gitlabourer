package com.jetbrains.kmpapp.feature.login.data.api.mapper

import com.jetbrains.kmpapp.feature.login.data.api.model.ApiUser
import com.jetbrains.kmpapp.feature.login.domain.model.User

internal class ApiUserMapper {
    fun map(user: ApiUser): User = with(user) {
            User(
                id = id,
                username = username,
                name = name,
                state = state,
                avatarUrl = avatarUrl,
                webUrl = webUrl,
                email = email
            )
        }
}
