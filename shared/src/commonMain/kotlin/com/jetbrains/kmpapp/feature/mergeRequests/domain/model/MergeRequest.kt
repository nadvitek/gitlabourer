package com.jetbrains.kmpapp.feature.mergeRequests.domain.model

import com.jetbrains.kmpapp.feature.login.domain.model.User
import kotlinx.datetime.Instant
import kotlinx.datetime.LocalDate

public enum class MRState { OPENED, MERGED, CLOSED, LOCKED, UNKNOWN }
public enum class MergeStatus { CAN_BE_MERGED, CANNOT_BE_MERGED, CHECKING, MERGEABLE, UNKNOWN }

public data class GitlabUser(
    val id: String,
    val username: String,
    val name: String,
    val avatarUrl: String?,
    val webUrl: String?
)

public data class Milestone(
    val id: String,
    val iid: String?,
    val title: String,
    val description: String?,
    val state: String?,
    val createdAt: Instant?,
    val updatedAt: Instant?,
    val dueDate: LocalDate?,
    val startDate: LocalDate?
)

public data class TimeStats(
    val estimateSeconds: Long,
    val totalSpentSeconds: Long,
    val humanEstimate: String?,
    val humanTotalSpent: String?
)

public data class TaskStatus(
    val count: Int,
    val completed: Int
)

public data class MergeRequest(
    val id: Long,
    val iid: Long,
    val projectId: Long,

    val title: String,
    val description: String?,

    val sourceBranch: String,
    val targetBranch: String,

    val state: MRState,
    val createdAt: Instant,
    val updatedAt: Instant,
    val mergedAt: Instant?,
    val closedAt: Instant?,

    val pipeline: Pipeline?,

    val author: User,
    val assignees: List<User>,
    val reviewers: List<User>,
    val mergedBy: User?,
    val closedBy: User?,

    val labels: List<Label>,
    val milestone: Milestone?,

    val upvotes: Int,
    val downvotes: Int,

    val mergeWhenPipelineSucceeds: Boolean?,
    val mergeStatus: MergeStatus?,
    val detailedMergeStatus: MergeStatus?,
    val draft: Boolean,
    val discussionLocked: Boolean?,
    val shouldRemoveSourceBranch: Boolean?,
    val forceRemoveSourceBranch: Boolean?,
    val squash: Boolean?,
    val squashCommitSha: String?,
    val isApproved: Boolean,

    val sha: String?,
    val mergeCommitSha: String?,
    val reference: String?,
    val webUrl: String?,

    val timeStats: TimeStats?,
    val taskStatus: TaskStatus?,

    val blockingDiscussionsResolved: Boolean?,
    val userNotesCount: Int?
) {
    val isOpen: Boolean get() = state == MRState.OPENED
    val isMergeable: Boolean? get() = when (detailedMergeStatus ?: mergeStatus) {
        MergeStatus.CAN_BE_MERGED, MergeStatus.MERGEABLE -> true
        MergeStatus.CANNOT_BE_MERGED -> false
        MergeStatus.CHECKING, null, MergeStatus.UNKNOWN -> null
    }
}
