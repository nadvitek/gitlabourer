package com.jetbrains.kmpapp.feature.pipelines.data

import com.jetbrains.kmpapp.feature.pipelines.domain.PipelinesRepository
import com.jetbrains.kmpapp.feature.pipelines.domain.model.DetailedPipeline

internal class PipelinesRepositoryImpl(
    val remoteDataSource: PipelinesRemoteDataSource
): PipelinesRepository {
    override suspend fun getPipelines(projectId: Int, pageNumber: Int): List<DetailedPipeline> {
        return remoteDataSource.getPipelines(projectId, pageNumber)
    }
}
