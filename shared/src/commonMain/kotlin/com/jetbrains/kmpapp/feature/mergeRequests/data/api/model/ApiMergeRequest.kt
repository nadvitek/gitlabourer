package com.jetbrains.kmpapp.feature.mergeRequests.data.api.model

import com.jetbrains.kmpapp.feature.login.data.api.model.ApiUser
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiLabel
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.datetime.Instant

@Serializable
internal data class ApiMergeRequest(
    @SerialName("id")
    val id: Long,
    @SerialName("iid")
    val iid: Long,
    @SerialName("project_id")
    val projectId: Long,
    @SerialName("title")
    val title: String,
    @SerialName("description")
    val description: String? = null,
    @SerialName("source_branch")
    val sourceBranch: String,
    @SerialName("target_branch")
    val targetBranch: String,
    @SerialName("source_project_id")
    val sourceProjectId: Long? = null,
    @SerialName("target_project_id")
    val targetProjectId: Long? = null,
    @SerialName("state")
    val state: String,
    @SerialName("created_at")
    val createdAt: Instant,
    @SerialName("updated_at")
    val updatedAt: Instant,
    @SerialName("merged_at")
    val mergedAt: Instant? = null,
    @SerialName("closed_at")
    val closedAt: Instant? = null,
    @SerialName("author")
    val author: ApiUser,
    @SerialName("assignees")
    val assignees: List<ApiUser> = emptyList(),
    @SerialName("reviewers")
    val reviewers: List<ApiUser> = emptyList(),
    @SerialName("merged_by")
    val mergedBy: ApiUser? = null,
    @SerialName("closed_by")
    val closedBy: ApiUser? = null,
    @SerialName("labels")
    val labels: List<ApiLabel> = emptyList(),
    @SerialName("milestone")
    val milestone: ApiMilestone? = null,
    @SerialName("upvotes")
    val upvotes: Int = 0,
    @SerialName("downvotes")
    val downvotes: Int = 0,
    @SerialName("merge_when_pipeline_succeeds")
    val mergeWhenPipelineSucceeds: Boolean? = null,
    @SerialName("merge_status")
    val mergeStatus: String? = null,
    @SerialName("detailed_merge_status")
    val detailedMergeStatus: String? = null,
    @SerialName("draft")
    val draft: Boolean = false,
    @SerialName("discussion_locked")
    val discussionLocked: Boolean? = null,
    @SerialName("should_remove_source_branch")
    val shouldRemoveSourceBranch: Boolean? = null,
    @SerialName("force_remove_source_branch")
    val forceRemoveSourceBranch: Boolean? = null,
    @SerialName("squash")
    val squash: Boolean? = null,
    @SerialName("squash_commit_sha")
    val squashCommitSha: String? = null,
    @SerialName("sha")
    val sha: String? = null,
    @SerialName("merge_commit_sha")
    val mergeCommitSha: String? = null,
    @SerialName("reference")
    val reference: String? = null,
    @SerialName("web_url")
    val webUrl: String? = null,
    @SerialName("time_stats")
    val timeStats: ApiTimeStats? = null,
    @SerialName("task_completion_status")
    val taskCompletionStatus: ApiTaskCompletionStatus? = null,
    @SerialName("blocking_discussions_resolved")
    val blockingDiscussionsResolved: Boolean? = null,
    @SerialName("user_notes_count")
    val userNotesCount: Int? = null
)

@Serializable
internal data class ApiMilestone(
    @SerialName("id")
    val id: Long,
    @SerialName("iid")
    val iid: Long? = null,
    @SerialName("title")
    val title: String,
    @SerialName("description")
    val description: String? = null,
    @SerialName("state")
    val state: String? = null,
    @SerialName("created_at")
    val createdAt: Instant? = null,
    @SerialName("updated_at")
    val updatedAt: Instant? = null,
    @SerialName("due_date")
    val dueDate: String? = null,
    @SerialName("start_date")
    val startDate: String? = null
)

@Serializable
internal data class ApiTimeStats(
    @SerialName("time_estimate")
    val timeEstimateSeconds: Long = 0,
    @SerialName("total_time_spent")
    val totalTimeSpentSeconds: Long = 0,
    @SerialName("human_time_estimate")
    val humanTimeEstimate: String? = null,
    @SerialName("human_total_time_spent")
    val humanTotalTimeSpent: String? = null
)

@Serializable
internal data class ApiTaskCompletionStatus(
    @SerialName("count")
    val count: Int = 0,
    @SerialName("completed")
    val completed: Int = 0
)
