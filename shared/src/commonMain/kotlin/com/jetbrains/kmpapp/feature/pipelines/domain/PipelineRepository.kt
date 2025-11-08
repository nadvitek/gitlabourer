package com.jetbrains.kmpapp.feature.pipelines.domain

import com.jetbrains.kmpapp.feature.pipelines.domain.model.DetailedPipeline

internal interface PipelinesRepository {
    suspend fun getPipelines(projectId: Int, pageNumber: Int): List<DetailedPipeline>
}
