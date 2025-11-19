package com.jetbrains.kmpapp.feature.notification.domain.usecase

import com.jetbrains.kmpapp.feature.notification.domain.NotificationRepository
import com.jetbrains.kmpapp.feature.notification.domain.model.PipelineUpdate
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flowOn

@KoinKmmExport
public interface ObservePipelineUpdatesUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(userId: String): Flow<List<PipelineUpdate>>
}

internal class ObservePipelineUpdatesUseCaseImpl(
    private val repository: NotificationRepository,
    private val ioDispatcher: CoroutineDispatcher,
) : ObservePipelineUpdatesUseCase {

    override suspend fun invoke(
        userId: String
    ): Flow<List<PipelineUpdate>> =
        repository.observePipelineUpdates(userId)
            .flowOn(ioDispatcher)
}
