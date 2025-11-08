package com.jetbrains.kmpapp.feature.pipelines.domain.usecase

import com.jetbrains.kmpapp.feature.pipelines.domain.PipelinesRepository
import com.jetbrains.kmpapp.feature.pipelines.domain.model.DetailedPipeline
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface GetPipelinesForProjectUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(projectId: Int, pageNumber: Int): List<DetailedPipeline>
}

internal class GetPipelinesForProjectUseCaseImpl(
    private val pipelinesRepository: PipelinesRepository
) : GetPipelinesForProjectUseCase {

    override suspend fun invoke(projectId: Int, pageNumber: Int): List<DetailedPipeline> {
        return pipelinesRepository.getPipelines(projectId, pageNumber)
    }
}
