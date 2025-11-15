package com.jetbrains.kmpapp.feature.login.data

import com.jetbrains.kmpapp.feature.login.domain.LoginRepository
import com.jetbrains.kmpapp.feature.login.domain.model.User

internal class LoginRepositoryImpl(
    private val loginRemoteDataSource: LoginRemoteDataSource
): LoginRepository {

    override suspend fun login(): User? {
        return loginRemoteDataSource.login()
    }

    override suspend fun getUser(): User? {
        return loginRemoteDataSource.getUser()
    }
}
