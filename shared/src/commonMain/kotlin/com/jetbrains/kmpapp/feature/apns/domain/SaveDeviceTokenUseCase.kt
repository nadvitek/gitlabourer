package com.jetbrains.kmpapp.feature.token.domain

import com.jetbrains.kmpapp.feature.apns.data.ApnsLocalDataSource
import com.jetbrains.kmpapp.feature.token.data.TokenLocalDataSource
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface SaveDeviceTokenUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(deviceToken: String)
}

internal class SaveDeviceTokenUseCaseImpl(
    private val apnsLocalDataSource: ApnsLocalDataSource
) : SaveDeviceTokenUseCase {

    override suspend fun invoke(deviceToken: String) {
        apnsLocalDataSource.saveToken(deviceToken)
    }
}
