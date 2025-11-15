package com.jetbrains.kmpapp.feature.login.domain.usecase

import com.jetbrains.kmpapp.core.network.data.ApiLocalDataSource
import com.jetbrains.kmpapp.feature.token.data.TokenLocalDataSource
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface LogoutUseCase {

    public suspend operator fun invoke()
}

internal class LogoutUseCaseImpl(
    private val tokenLocalDataSource: TokenLocalDataSource,
    private val apiLocalDataSource: ApiLocalDataSource
) : LogoutUseCase {

    override suspend fun invoke() {
        tokenLocalDataSource.clear()
        apiLocalDataSource.clear()
    }
}
