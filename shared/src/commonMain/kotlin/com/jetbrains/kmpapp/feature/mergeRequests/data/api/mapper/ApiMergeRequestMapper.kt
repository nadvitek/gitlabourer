package com.jetbrains.kmpapp.feature.mergerequest.data.api.mapper

import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiLabel
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiGitlabUser
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiMergeRequest
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiMilestone
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiTaskCompletionStatus
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.model.ApiTimeStats
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.GitlabUser
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.Label
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MRState
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequest
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeStatus
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.Milestone
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.TaskStatus
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.TimeStats
import kotlinx.datetime.Instant
import kotlinx.datetime.LocalDate
import kotlinx.datetime.TimeZone
import kotlinx.datetime.toLocalDateTime
import kotlin.runCatching

internal class ApiMergeRequestMapper {

    fun map(api: ApiMergeRequest): MergeRequest = MergeRequest(
        id = api.id.toString(),
        iid = api.iid.toString(),
        projectId = api.projectId.toString(),
        title = api.title,
        description = api.description,
        sourceBranch = api.sourceBranch,
        targetBranch = api.targetBranch,
        state = api.state.toMRState(),
        createdAt = api.createdAt,
        updatedAt = api.updatedAt,
        mergedAt = api.mergedAt,
        closedAt = api.closedAt,
        pipeline = null,
        author = map(api.author),
        assignees = api.assignees.map(::map),
        reviewers = api.reviewers.map(::map),
        mergedBy = api.mergedBy?.let(::map),
        closedBy = api.closedBy?.let(::map),
        labels = api.labels.map(::map),
        milestone = api.milestone?.let(::map),
        upvotes = api.upvotes,
        downvotes = api.downvotes,
        mergeWhenPipelineSucceeds = api.mergeWhenPipelineSucceeds,
        mergeStatus = api.mergeStatus?.toMergeStatus(),
        detailedMergeStatus = api.detailedMergeStatus?.toMergeStatus(),
        draft = api.draft,
        discussionLocked = api.discussionLocked,
        shouldRemoveSourceBranch = api.shouldRemoveSourceBranch,
        forceRemoveSourceBranch = api.forceRemoveSourceBranch,
        squash = api.squash,
        squashCommitSha = api.squashCommitSha,
        isApproved = false,
        sha = api.sha,
        mergeCommitSha = api.mergeCommitSha,
        reference = api.reference,
        webUrl = api.webUrl,
        timeStats = api.timeStats?.let(::map),
        taskStatus = api.taskCompletionStatus?.let(::map),
        blockingDiscussionsResolved = api.blockingDiscussionsResolved,
        userNotesCount = api.userNotesCount
    )

    private fun map(api: ApiLabel): Label = Label(
        name = api.name,
        color = api.color,
        textColor = api.textColor
    )

    private fun map(api: ApiGitlabUser): GitlabUser = GitlabUser(
        id = api.id.toString(),
        username = api.username,
        name = api.name,
        avatarUrl = api.avatarUrl,
        webUrl = api.webUrl
    )

    private fun map(api: ApiMilestone): Milestone = Milestone(
        id = api.id.toString(),
        iid = api.iid?.toString(),
        title = api.title,
        description = api.description,
        state = api.state,
        createdAt = api.createdAt,
        updatedAt = api.updatedAt,
        dueDate = api.dueDate.toLocalDateOrNull(),
        startDate = api.startDate.toLocalDateOrNull()
    )

    private fun map(api: ApiTimeStats): TimeStats = TimeStats(
        estimateSeconds = api.timeEstimateSeconds,
        totalSpentSeconds = api.totalTimeSpentSeconds,
        humanEstimate = api.humanTimeEstimate,
        humanTotalSpent = api.humanTotalTimeSpent
    )

    private fun map(api: ApiTaskCompletionStatus): TaskStatus = TaskStatus(
        count = api.count,
        completed = api.completed
    )

    private fun String?.toLocalDateOrNull(): LocalDate? =
        this?.let {
            runCatching {
                Instant.parse("${it}T00:00:00Z")
                    .toLocalDateTime(TimeZone.UTC)
                    .date
            }.getOrNull()
        }


    private fun String?.toMRState(): MRState = when (this?.lowercase()) {
        "opened" -> MRState.OPENED
        "merged" -> MRState.MERGED
        "closed" -> MRState.CLOSED
        "locked" -> MRState.LOCKED
        else -> MRState.UNKNOWN
    }

    private fun String?.toMergeStatus(): MergeStatus = when (this?.lowercase()) {
        "can_be_merged" -> MergeStatus.CAN_BE_MERGED
        "cannot_be_merged" -> MergeStatus.CANNOT_BE_MERGED
        "checking" -> MergeStatus.CHECKING
        "mergeable" -> MergeStatus.MERGEABLE
        else -> MergeStatus.UNKNOWN
    }
}
