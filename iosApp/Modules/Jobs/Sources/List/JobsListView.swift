import SwiftUI
import GitLabourerUI
import shared

struct JobsListView: View {

    // MARK: - Properties

    let list: [DetailedJob]
    let hasNextPage: Bool
    let isLoadingNextPage: Bool

    let handleAction: (JobsAction) -> Void
    let refresh: () async -> Void

    // MARK: - UI

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                alignment: .center,
                spacing: 12
            ) {
                ForEach(list, id: \.id) { job in
                    Button {
                        handleAction(.open(job))
                    } label: {
                        jobView(for: job)
                    }
                }

                if hasNextPage {
                    PrimaryButton(
                        "Load more",
                        isLoading: isLoadingNextPage
                    ) {
                        handleAction(.loadNextPage)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 16)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
        .refreshable {
            await refresh()
        }
    }

    // MARK: - Private helper

    private func jobView(for job: DetailedJob) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                if let name = job.name {
                    HStack(spacing: 0) {
                        Text("Job")
                            .font(.body)
                            .fontWeight(.semibold)

                        Spacer()

                        Button {
                            handleAction(.openLink(job.webUrl))
                        } label: {
                            Image(systemName: "link.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(GitlabColors.gitlabOrangeTwo.swiftUIColor)
                        }
                    }

                    Text(name)
                        .font(.body)
                }
            }


            HStack(alignment: .top, spacing: 0) {
                if let initials = job.user?.name.getNameInitials() {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Author")
                            .font(.body)
                            .fontWeight(.semibold)

                        userComponent(initials)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Status")
                        .font(.body)
                        .fontWeight(.semibold)

                    JobStateView(state: job.status)
                        .frame(width: 22, height: 22)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }


            HStack(spacing: 10) {
                HStack(spacing: 4) {
                    if let duration = job.durationSeconds {
                        Image(systemName: "clock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)

                        Text(duration.asDurationString())
                            .font(.footnote)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 4) {
                    let date = job.finishedAt ?? job.startedAt ?? job.createdAt

                    if let date {
                        Image(systemName: "calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)

                        Text(date.relativeString())
                            .font(.footnote)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(GitlabColors.gitlabOrange.swiftUIColor.opacity(0.05))
        .clipShape(.rect(cornerRadius: 12))
        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
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
}

struct JobsListView_Previews: PreviewProvider {
    static var previews: some View {
        JobsListView(
            list: [
                .mock(),
                .mock(id: 2, name: "Assemble"),
                .mock(id: 3, name: "Lint"),
                .mock(id: 4, name: "Unit Tests")
            ],
            hasNextPage: false,
            isLoadingNextPage: false,
            handleAction: { _ in },
            refresh: {}
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gitlabourerBackground()
        .preferredColorScheme(.dark)
    }
}
