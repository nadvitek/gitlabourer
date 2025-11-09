import SwiftUI
import shared
import GitLabourerUI

struct JobsStreamView: View {

    // MARK: - Properties

    let stream: JobsStream
    let handleAction: (JobsAction) -> Void

    // MARK: - UI

    var body: some View {
        VStack(spacing: 12) {
            sectionsView(stream)

            if !stream.downstreams.isEmpty {
                Image(systemName: "chevron.down.2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }

            HStack(alignment: .top, spacing: 30) {
                ForEach(stream.downstreams, id:\.pipelineId) { stream in
                    JobsStreamView(stream: stream, handleAction: handleAction)
                }
            }
        }
    }

    // MARK: - Private helpers

    private func sectionsView(_ stream: JobsStream) -> some View {
        VStack(spacing: 0) {
            ForEach(stream.sections, id: \.stage) { section in
                VStack(spacing: 0) {
                    JobsSectionView(section: section, handleAction: handleAction)

                    if stream.sections.last != section {
                        GitlabColors.gitlabGray.swiftUIColor.opacity(0.7)
                            .frame(width: 3, height: 30)
                    }
                }
            }
        }
        .padding(12)
        .background(GitlabColors.gitlabGray.swiftUIColor.opacity(0.1))
        .clipShape(.rect(cornerRadius: 12))
    }
}

#if DEBUG

// MARK: - Previews

#Preview {
    JobsStreamView(
        stream: .init(
            pipelineId: 1,
            projectId: 1,
            sections: [.mock(), .mock(stage: "build")],
            downstreams: []
        ),
        handleAction: { _ in } 
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .gitlabourerBackground()
    .preferredColorScheme(.dark)
}

#endif
