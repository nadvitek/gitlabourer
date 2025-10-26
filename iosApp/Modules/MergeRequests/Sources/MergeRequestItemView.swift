import SwiftUI
import shared
import GitLabourerUI

struct MergeRequestItemView: View {

    // MARK: - Properties

    let mr: MergeRequest

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 0) {
                Text(mr.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)

                if mr.isApproved {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(GitlabColors.success.swiftUIColor)
                }
            }

            if mr.labels.isEmpty {
                nonLabelsLanes
            } else {
                labelsLanes
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background {
            LinearGradient(
                colors: [
                    GitlabColors.gitlabAccent.swiftUIColor
                        .opacity(0.4),
                    GitlabColors.gitlabDark.swiftUIColor.opacity(0.6),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .clipShape(.rect(cornerRadius: 32))
        .overlay {
            RoundedRectangle(cornerRadius: 32)
                .stroke(GitlabColors.gitlabGray.swiftUIColor, lineWidth: 2)
        }
    }

    // MARK: - Private helpers

    private func initialComponent(_ text: String) -> some View {
        Text(text)
            .fontWeight(.semibold)
            .font(.caption2)
            .foregroundStyle(GitlabColors.gitlabDark.swiftUIColor)
            .padding(5)
            .background(GitlabColors.gitlabGray.swiftUIColor)
            .clipShape(.circle)
    }

    @ViewBuilder
    private var labelsLanes: some View {
        HStack(spacing: 0) {
            HStack(spacing: 4) {
                ForEach(mr.labels, id: \.self) { label in
                    Text(label.name)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(label.textColor.convertToColor())
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(label.color.convertToColor())
                        .clipShape(.rect(cornerRadius: 32))
                }
            }
            .padding(.leading, -4)

            Spacer()

            if let status = mr.pipeline?.status {
                JobStateView(state: status)
            }
        }
        .frame(height: 22)

        HStack(spacing: 8) {
            Image(systemName: "point.topleft.filled.down.to.point.bottomright.curvepath")
                .resizable()
                .scaledToFit()
                .frame(width: 12)

            Text(mr.targetBranch)
                .font(.caption2)
                .fontWeight(.semibold)
                .lineLimit(1)

            Spacer()


            HStack(spacing: 2) {
                if let assignee = mr.assignees.first {
                    initialComponent(
                        assignee.name.getNameInitials()
                    )
                }


                if let reviewer = mr.reviewers.first {
                    initialComponent(
                        reviewer.name.getNameInitials()
                    )
                }
            }
        }
    }

    private var nonLabelsLanes: some View {
        HStack(spacing: 8) {
            Image(systemName: "point.topleft.filled.down.to.point.bottomright.curvepath")
                .resizable()
                .scaledToFit()
                .frame(width: 12)

            Text(mr.targetBranch)
                .font(.caption2)
                .fontWeight(.semibold)
                .lineLimit(1)

            Spacer()


            HStack(spacing: 2) {
                if let status = mr.pipeline?.status {
                    JobStateView(state: status)
                        .padding(.leading, 2)
                }

                if let assignee = mr.assignees.first {
                    initialComponent(
                        assignee.name.getNameInitials()
                    )
                }

                if let reviewer = mr.reviewers.first {
                    initialComponent(
                        reviewer.name.getNameInitials()
                    )
                }
            }
        }
        .frame(height: 22)
    }
}

#Preview {
    VStack(spacing: 12) {
        MergeRequestItemView(
            mr: MergeRequestMockFactory.makeMergeRequest(
                pipelineStatus: .canceled
            )
        )

        MergeRequestItemView(
            mr: MergeRequestMockFactory.makeMergeRequest(
                pipelineStatus: .failed,
                labels: [.init(
                    name: "Auto-merge",
                    color: "#9400d3",
                    textColor: "#FFFFFF"
                )]
            )
        )
    }
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .gitlabourerBackground()
    .preferredColorScheme(.dark)
}
