package com.jetbrains.kmpapp.feature.login.domain.usecase

import com.jetbrains.kmpapp.core.network.data.ApiLocalDataSource
import com.jetbrains.kmpapp.feature.login.domain.LoginRepository
import com.jetbrains.kmpapp.feature.login.domain.model.User
import com.jetbrains.kmpapp.feature.token.data.TokenLocalDataSource
import com.jetbrains.kmpapp.feature.token.domain.model.AuthTokens
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface LoginUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(url: String, token: String): User?
}

internal class LoginUseCaseImpl(
    private val tokenLocalDataSource: TokenLocalDataSource,
    private val apiLocalDataSource: ApiLocalDataSource,
    private val loginRepository: LoginRepository
) : LoginUseCase {

    override suspend fun invoke(url: String, token: String): User? {
        val authTokens = AuthTokens(privateToken = token)
        tokenLocalDataSource.saveTokens(authTokens)
        apiLocalDataSource.saveUrl(url)
        return loginRepository.login()
    }
}
