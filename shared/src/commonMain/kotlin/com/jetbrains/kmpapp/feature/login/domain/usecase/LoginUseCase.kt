package com.jetbrains.kmpapp.feature.login.domain.usecase

import com.jetbrains.kmpapp.feature.login.domain.LoginRepository
import com.jetbrains.kmpapp.feature.login.domain.model.User
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface LoginUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(token: String): User?
}

internal class LoginUseCaseImpl(
    private val loginRepository: LoginRepository
) : LoginUseCase {

    override suspend fun invoke(token: String): User? {
        return loginRepository.login(token)
    }
}
