import Foundation
import shared
import Core

#if DEBUG

public enum MergeRequestMockFactory {
    public static func makeMilestone(
        id: String = "m-1",
        iid: String? = "10",
        title: String = "v1.2 Release",
        description: String? = "Stability improvements and bug fixes.",
        state: String? = "active",
        createdAt: Kotlinx_datetimeInstant? = nil,
        updatedAt: Kotlinx_datetimeInstant? = nil,
        dueDate: Kotlinx_datetimeLocalDate? = nil,
        startDate: Kotlinx_datetimeLocalDate? = nil,
    ) -> Milestone {
        Milestone(
            id: id,
            iid: iid,
            title: title,
            description: description,
            state: state,
            createdAt: createdAt,
            updatedAt: updatedAt,
            dueDate: dueDate,
            startDate: startDate
        )
    }

    public static func makeTimeStats(
        estimateSeconds: Int64 = 14_400,
        totalSpentSeconds: Int64 = 7_200,
        humanEstimate: String? = "4h",
        humanTotalSpent: String? = "2h"
    ) -> TimeStats {
        TimeStats(
            estimateSeconds: estimateSeconds,
            totalSpentSeconds: totalSpentSeconds,
            humanEstimate: humanEstimate,
            humanTotalSpent: humanTotalSpent
        )
    }

    public static func makeTaskStatus(
        count: Int32 = 5,
        completed: Int32 = 2
    ) -> TaskStatus {
        TaskStatus(
            count: count,
            completed: completed
        )
    }

    public static func makeMergeRequest(
        id: Int64 = 12345,
        iid: Int64 = 1,
        projectId: Int64 = 987,
        title: String = "Fix login crash on iOS",
        description: String? = "This MR fixes a crash when tapping the login button on iOS 18.",
        sourceBranch: String = "feature/fix-login-crash",
        targetBranch: String = "main",
        state: MRState = .opened,
        createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        updatedAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000),
        mergedAt: Kotlinx_datetimeInstant? = nil,
        closedAt: Kotlinx_datetimeInstant? = nil,
        pipelineStatus: PipelineStatus,
        author: User = .mock(),
        assignees: [User] = [.mock(id: 3, username: "bwayne", name: "Bruce Wayne")],
        reviewers: [User] = [.mock(id: 4, username: "ckent", name: "Clark Kent")],
        mergedBy: User? = nil,
        closedBy: User? = nil,
        labels: [shared.Label] = [],
        milestone: Milestone? = makeMilestone(),
        upvotes: Int32 = 7,
        downvotes: Int32 = 0,
        mergeWhenPipelineSucceeds: Bool? = true,
        mergeStatus: MergeStatus? = .mergeable,
        detailedMergeStatus: MergeStatus? = .canBeMerged,
        draft: Bool = false,
        discussionLocked: Bool? = false,
        shouldRemoveSourceBranch: Bool? = true,
        forceRemoveSourceBranch: Bool? = nil,
        squash: Bool? = true,
        squashCommitSha: String? = nil,
        sha: String? = "abcdef1234567890",
        mergeCommitSha: String? = nil,
        reference: String? = "!1",
        webUrl: String? = "https://gitlab.example.com/proj/merge_requests/1",
        timeStats: TimeStats? = makeTimeStats(),
        taskStatus: TaskStatus? = makeTaskStatus(),
        blockingDiscussionsResolved: Bool? = true,
        userNotesCount: Int32? = 3
    ) -> MergeRequest {
        MergeRequest(
            id: id,
            iid: iid,
            projectId: projectId,
            title: title,
            description: description,
            sourceBranch: sourceBranch,
            targetBranch: targetBranch,
            state: state,
            createdAt: Kotlinx_datetimeInstant.Companion().fromEpochMilliseconds(epochMilliseconds: createdAt),
            updatedAt: Kotlinx_datetimeInstant.Companion().fromEpochMilliseconds(epochMilliseconds: updatedAt),
            mergedAt: mergedAt,
            closedAt: closedAt,
            pipeline: .init(
                id: "",
                sha: "",
                ref: "",
                status: pipelineStatus
            ),
            author: author,
            assignees: assignees,
            reviewers: reviewers,
            mergedBy: mergedBy,
            closedBy: closedBy,
            labels: labels,
            milestone: milestone,
            upvotes: upvotes,
            downvotes: downvotes,
            mergeWhenPipelineSucceeds: false,
            mergeStatus: mergeStatus,
            detailedMergeStatus: detailedMergeStatus,
            draft: draft,
            discussionLocked: false,
            shouldRemoveSourceBranch: false,
            forceRemoveSourceBranch: false,
            squash: false,
            squashCommitSha: squashCommitSha,
            isApproved: false,
            sha: sha,
            mergeCommitSha: mergeCommitSha,
            reference: reference,
            webUrl: webUrl,
            timeStats: timeStats,
            taskStatus: taskStatus,
            blockingDiscussionsResolved: false,
            userNotesCount: nil
        )
    }

    // Convenience list
    public static func makeList(count: Int = 3) -> [MergeRequest] {
        guard count > 0 else { return [] }
        var list: [MergeRequest] = []
        for i in 0..<count {
            let state: MRState = (i % 3 == 0) ? .opened : (i % 3 == 1) ? .merged : .closed
            list.append(
                makeMergeRequest(
                    id: Int64(i),
                    iid: Int64(i + 1),
                    title: ["🐛Fix login crash", "✨Add dark mode", "🚑Hotfix background fetch"][i % 3],
                    state: state,
                    createdAt: Int64(Date().timeIntervalSince1970 * 1000),
                    updatedAt: Int64(Date().timeIntervalSince1970 * 1000),
                    mergedAt: state == .merged ? Kotlinx_datetimeInstant.Companion().fromEpochMilliseconds(epochMilliseconds: Int64(Date().timeIntervalSince1970 * 1000)) : nil,
                    pipelineStatus: .success,
                    milestone: (i % 2 == 0) ? makeMilestone() : nil,
                    upvotes: Int32(5 + i),
                    downvotes: Int32(i % 2)
                )
            )
        }
        return list
    }
}

#endif
