package com.jetbrains.kmpapp.feature.pipelines.domain

import com.jetbrains.kmpapp.feature.pipelines.domain.model.DetailedPipeline
import com.jetbrains.kmpapp.feature.pipelines.domain.model.PipelinesPage

internal interface PipelinesRepository {
    suspend fun getPipelines(projectId: Int, pageNumber: Int): PipelinesPage
}
