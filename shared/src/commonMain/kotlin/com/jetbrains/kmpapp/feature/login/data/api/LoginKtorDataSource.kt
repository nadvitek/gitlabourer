package com.jetbrains.kmpapp.feature.login.data.api

import com.jetbrains.kmpapp.core.network.GitlabApiClient
import com.jetbrains.kmpapp.feature.login.data.LoginRemoteDataSource
import com.jetbrains.kmpapp.feature.login.data.api.mapper.ApiUserMapper
import com.jetbrains.kmpapp.feature.login.data.api.model.ApiUser
import com.jetbrains.kmpapp.feature.login.domain.model.User

internal class LoginKtorDataSource(
    private val apiClient: GitlabApiClient
) : LoginRemoteDataSource {

    private val apiUserMapper = ApiUserMapper()

    override suspend fun login(token: String): User? {
        return try {
            val user = apiClient.get<ApiUser>(
                endpoint = LoginRemoteDataSource.USER
            )

            apiUserMapper.map(user)
        } catch (e: Exception) {
            e.printStackTrace()

            null
        }
    }
}
