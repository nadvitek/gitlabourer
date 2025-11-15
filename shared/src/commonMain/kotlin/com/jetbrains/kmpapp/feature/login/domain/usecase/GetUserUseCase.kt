package com.jetbrains.kmpapp.feature.login.domain.usecase

import com.jetbrains.kmpapp.feature.login.domain.LoginRepository
import com.jetbrains.kmpapp.feature.login.domain.model.User
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface GetUserUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(): User?
}

internal class GetUserUseCaseImpl(
    private val loginRepository: LoginRepository
) : GetUserUseCase {

    override suspend fun invoke(): User? {
        return loginRepository.getUser()
    }
}
