import SwiftUI
import GitLabourerUI
import shared
import Core

public struct MergeRequestDetailView<ViewModel: MergeRequestDetailViewModel>: View {

    // MARK: - Properties

    @State private var viewModel: ViewModel

    // MARK: - Initializers

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - UI

    public var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gitlabourerBackground()
            .onAppear(perform: viewModel.onAppear)

    }

    // MARK: - Private helpers

    @ViewBuilder
    private var content: some View {
        switch viewModel.screenState {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case let .loaded(mergeRequestDetail):
            loadedView(detail: mergeRequestDetail)

        case .error:
            ErrorStateView(
                isLoading: viewModel.isRetryLoading,
                retry: viewModel.retry
            )
        }
    }

    private func loadedView(detail: MergeRequestDetail) -> some View {
        ScrollViewThatFits {
            VStack(spacing: 20) {
                basicInfo(detail)

                divider

                peopleComponents(detail)

                divider

                approvals(detail)

                divider

                buttons(detail)

                if detail.state == .opened {
                    divider

                    PrimaryButton(
                        "Merge",
                        isLoading: viewModel.isMergeLoading,
                        action: viewModel.merge
                    )
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var divider: some View {
        GitlabColors.gitlabOrange.swiftUIColor
            .opacity(0.4)
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }

    private func approvals(_ detail: MergeRequestDetail) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Approvals:")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)

            HStack(spacing: 0) {
                if detail.approved {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(GitlabColors.success.swiftUIColor)
                }

                Text(detail.approved ? "Approved" : "Not approved")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)

                Spacer()

                SecondaryButton(
                    detail.approved ? "Unapprove" : "Approve",
                    isLoading: viewModel.isApprovalLoading,
                    action: viewModel.toggleApprove
                )
            }
        }
    }

    private func basicInfo(_ detail: MergeRequestDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(detail.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)

            Text(detail.state.name)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                .padding(6)
                .background(GitlabColors.gitlabOrange.swiftUIColor.opacity(0.5))
                .clipShape(.rect(cornerRadius: 12))

            HStack(spacing: 6) {
                Image(systemName: "point.topleft.filled.down.to.point.bottomright.curvepath")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12)

                Text("\(detail.sourceBranch) -> \(detail.targetBranch)")
                    .font(.subheadline)
                    .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                    .multilineTextAlignment(.leading)
            }

            divider

            Text(detail.description_)
                .font(.subheadline)
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)

            Button {
                viewModel.openUrl(urlString: detail.webUrl)
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "link")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)

                    Text("Link to web")
                        .font(.body)
                        .underline()
                        .fontWeight(.semibold)
                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func peopleComponents(_ detail: MergeRequestDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if let assignee = detail.assignee {
                Text("Assignee:")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)

                HStack(alignment: .top, spacing: 6) {
                    userComponent(assignee.name.getNameInitials())

                    Text(assignee.name)
                        .font(.headline)
                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                }
            }

            if let reviewer = detail.reviewers.first {
                Text("Reviewer:")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)

                HStack(alignment: .top, spacing: 6) {
                    userComponent(reviewer.name.getNameInitials())

                    Text(reviewer.name)
                        .font(.headline)
                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                }
            }

            if !detail.labels.isEmpty {
                Text("Labels:")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)

                ForEach(detail.labels, id: \.self) { label in
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
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func userComponent(_ text: String) -> some View {
        Text(text)
            .fontWeight(.semibold)
            .font(.caption2)
            .foregroundStyle(GitlabColors.gitlabDark.swiftUIColor)
            .padding(5)
            .background(GitlabColors.gitlabGray.swiftUIColor)
            .clipShape(.circle)
    }

    private func buttons(_ detail: MergeRequestDetail) -> some View {
        VStack(spacing: 12) {
            if let pipeline = detail.pipeline {
                Button {
                    viewModel.onPipelineClick(pipeline: pipeline)
                } label: {
                    HStack(spacing: 12) {
                        JobStateView(state: pipeline.status)
                            .frame(width: 30)

                        Text("Pipeline")
                            .font(.headline)



                        Spacer()

                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                    .padding(12)
                    .background(GitlabColors.gitlabOrange.swiftUIColor.opacity(0.05))
                    .clipShape(.rect(cornerRadius: 16))
                }
            }

            Button {
                viewModel.openUrl(urlString: "\(detail.webUrl)/commits")
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)

                    Text("Commits")
                        .font(.headline)

                    Spacer()

                    Image(systemName: "link")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                .padding(12)
                .background(GitlabColors.gitlabOrange.swiftUIColor.opacity(0.05))
                .clipShape(.rect(cornerRadius: 16))
            }

            Button {
                viewModel.openUrl(urlString: "\(detail.webUrl)/diffs")
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.left.arrow.right.square.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)

                    Text("Changes")
                        .font(.headline)

                    if let changesCount = detail.changesCount {
                        Text("\(changesCount)")
                            .font(.headline)
                            .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                            .padding(4)
                            .background(GitlabColors.gitlabOrangeTwo.swiftUIColor.opacity(0.5))
                            .clipShape(.rect(cornerRadius: 12))
                    }

                    Spacer()

                    Image(systemName: "link")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                .padding(12)
                .background(GitlabColors.gitlabOrange.swiftUIColor.opacity(0.05))
                .clipShape(.rect(cornerRadius: 16))
            }
        }
    }
}

#if DEBUG

// MARK: - Previews

struct MergeRequestDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MergeRequestDetailView(
            viewModel: MergeRequestDetailViewModelMock(
                screenState: .loaded(
                    MergeRequestDetail(
                        id: 1,
                        iid: 1,
                        projectId: 1,
                        title: "💄iOS Base setup",
                        description: "Setup base of iOS Application meaning:\n- TabBar\n- AppDelegate\n- AppIcon\n\nRelated: #101068",
                        labels: [.init(
                            name: "Auto-merge",
                            color: "#9400d3",
                            textColor: "#FFFFFF"
                        )],
                        assignee: .init(
                            id: 1,
                            username: "vit.nademlejnsky",
                            name: "Vít Nademlejnský",
                            state: "",
                            avatarUrl: "",
                            webUrl: "",
                            email: ""
                        ),
                        reviewers: [
                            .init(
                                id: 1,
                                username: "lukas.hromadnik",
                                name: "Lukáš Hromadník",
                                state: "",
                                avatarUrl: "",
                                webUrl: "",
                                email: ""
                            )
                        ],
                        webUrl: "",
                        sourceBranch: "development",
                        targetBranch: "main",
                        changesCount: "123",
                        pipeline: .init(
                            id: "",
                            sha: "",
                            ref: "",
                            status: .running
                        ),
                        state: .opened,
                        approved: false,
                        canMerge: true
                    )
                )
            )
        )
        .preferredColorScheme(.dark)
    }
}

#endif

