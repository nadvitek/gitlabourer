package com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model

import com.jetbrains.kmpapp.feature.login.domain.model.User
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.Label
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MRState
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.Pipeline

public data class MergeRequestDetail(
    val id: Long,
    val iid: Long,
    val projectId: Long,
    val title: String,
    val description: String,
    var labels: List<Label> = emptyList<Label>(),
    val assignee: User?,
    val reviewers: List<User>,
    val webUrl: String,
    val sourceBranch: String,
    val targetBranch: String,
    val changesCount: String?,
    val pipeline: Pipeline?,
    val state: MRState,
    var approved: Boolean,
    val canMerge: Boolean
)
