package com.jetbrains.kmpapp.feature.pipelines.domain.model

import com.jetbrains.kmpapp.core.model.domain.PageInfo

public data class PipelinesPage(
    val items: List<DetailedPipeline>,
    val pageInfo: PageInfo
)
