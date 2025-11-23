package com.jetbrains.kmpapp.feature.jobs.domain.model

import com.jetbrains.kmpapp.core.model.domain.PageInfo
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequest

public data class JobsPage(
    val items: List<DetailedJob>,
    val pageInfo: PageInfo
)
