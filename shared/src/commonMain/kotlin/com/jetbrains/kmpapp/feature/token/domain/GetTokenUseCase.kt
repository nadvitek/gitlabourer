package com.jetbrains.kmpapp.feature.token.domain

import com.jetbrains.kmpapp.feature.token.data.TokenLocalDataSource
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface GetTokenUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(): String?
}

internal class GetTokenUseCaseImpl(
    private val tokenLocalDataSource: TokenLocalDataSource,
) : GetTokenUseCase {

    override suspend fun invoke(): String? {
        return tokenLocalDataSource.extractToken()
    }
}
