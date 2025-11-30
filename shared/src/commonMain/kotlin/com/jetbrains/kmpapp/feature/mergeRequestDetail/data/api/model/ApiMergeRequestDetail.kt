package com.jetbrains.kmpapp.feature.mergeRequestDetail.data.api.model

import com.jetbrains.kmpapp.feature.login.data.api.model.ApiUser
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiPipeline
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class ApiMergeRequestDetail(
    @SerialName("id")
    val id: Long,
    @SerialName("iid")
    val iid: Long,
    @SerialName("project_id")
    val projectId: Long,
    @SerialName("title")
    val title: String,
    @SerialName("description")
    val description: String,
    @SerialName("labels")
    val labels: List<String>,
    @SerialName("assignee")
    val assignee: ApiUser?,
    @SerialName("reviewers")
    val reviewers: List<ApiUser>,
    @SerialName("web_url")
    val webUrl: String,
    @SerialName("source_branch")
    val sourceBranch: String,
    @SerialName("target_branch")
    val targetBranch: String,
    @SerialName("changes_count")
    val changesCount: String?,
    @SerialName("pipeline")
    val pipeline: ApiPipeline?,
    @SerialName("state")
    val state: String,
    @SerialName("approved")
    val approved: Boolean? = null,
    @SerialName("user")
    val user: ApiMergeRequestUser?
)

@Serializable
internal data class ApiMergeRequestUser(
    @SerialName("can_merge")
    val canMerge: Boolean?
)
