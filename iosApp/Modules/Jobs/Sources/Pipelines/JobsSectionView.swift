import SwiftUI
import shared
import GitLabourerUI

struct JobsSectionView: View {

    // MARK: - Properties

    let section: JobsSection
    let handleAction: (JobsAction) -> Void

    // MARK: - UI

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                Text(section.stage)
                    .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                    .fontWeight(.bold)
                    .padding(.horizontal, 12)
                    .padding(.top, 10)

                GitlabColors.gitlabDark.swiftUIColor
                    .frame(height: 1)
            }

            VStack(alignment: .leading, spacing: 12) {
                ForEach(section.jobs, id: \.id) { job in
                    HStack(spacing: 0) {
                        Button {
                            handleAction(.open(job))
                        } label: {
                            HStack(alignment: .top, spacing: 8) {
                                JobStateView(state: job.status)
                                    .frame(width: 20, height: 20)

                                if let name = job.name {
                                    Text(name)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                        }

                        Spacer()

                        actionsForJob(job)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 10)
        }
        .frame(width: 300)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(GitlabColors.gitlabDark.swiftUIColor, lineWidth: 2)
        }
        .background(GitlabColors.gitlabGray.swiftUIColor.opacity(0.15))
        .clipShape(.rect(cornerRadius: 12))
    }

    // MARK: - Private helpers

    @ViewBuilder
    private func actionsForJob(_ job: DetailedJob) -> some View {
        switch job.status {
        case .failed, .canceled:
            retryButton(job)
        case .running, .created, .pending, .preparing, .scheduled, .waitingForResource:
            cancelButton(job)
        default: EmptyView()
        }
    }

    private func retryButton(_ job: DetailedJob) -> some View {
        Button {
            handleAction(.retry(job))
        } label: {
            Image(systemName: "arrow.counterclockwise.circle")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
        }
    }

    private func cancelButton(_ job: DetailedJob) -> some View {
        Button {
            handleAction(.cancel(job))
        } label: {
            Image(systemName: "nosign")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
        }
    }
}

#if DEBUG

// MARK: - Previews

struct JobsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        JobsSectionView(section: .mock(), handleAction: { _ in })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gitlabourerBackground()
            .preferredColorScheme(.dark)
    }
}

extension JobsSection {
    static func mock(stage: String = "prepare") -> JobsSection {
        JobsSection(
            stage: stage,
            jobs: [
                .mock(),
                .mock(id: 2, status: .created, name: "Assemble"),
                .mock(id: 3, status: .failed, name: "Lint"),
                .mock(id: 4, status: .manual, name: "Unit Tests"),
                .mock(id: 5, status: .manual, name: "Unit Tests and some really really long text for testing")
            ]
        )
    }
}

#endif
