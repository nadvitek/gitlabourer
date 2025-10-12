package com.jetbrains.kmpapp.feature.login.domain.usecase

import com.jetbrains.kmpapp.feature.token.data.TokenLocalDataSource
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface LogoutUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke()
}

internal class LogoutUseCaseImpl(
    private val tokenLocalDataSource: TokenLocalDataSource
) : LogoutUseCase {

    override suspend fun invoke() {
        tokenLocalDataSource.clear()
    }
}
