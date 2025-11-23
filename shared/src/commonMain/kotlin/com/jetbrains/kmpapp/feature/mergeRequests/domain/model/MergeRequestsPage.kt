package com.jetbrains.kmpapp.feature.mergeRequests.domain.model

import com.jetbrains.kmpapp.core.model.domain.PageInfo

public data class MergeRequestsPage(
    val items: List<MergeRequest>,
    val pageInfo: PageInfo
)
