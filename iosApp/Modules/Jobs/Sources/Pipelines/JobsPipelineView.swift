import SwiftUI
import shared
import GitLabourerUI
import Core

struct JobsPipelineView: View {

    // MARK: - Properties

    let stream: JobsStream
    let handleAction: (JobsAction) -> Void

    var axes: Axis.Set {
        stream.hasTwoOrMoreDownstreams() ?
        [.vertical, .horizontal] :
        [.vertical]
    }

    // MARK: - UI

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(axes) {
                VStack(spacing: 20) {
                    Text(stream.pipelineName ?? "")
                        .font(.title3)
                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                        .fontWeight(.semibold)
                        .id("pipeline")

                    JobsStreamView(stream: stream, handleAction: handleAction)
                }
            }
            .scrollIndicators(.hidden)
            .onAppear {
                proxy.scrollTo("pipeline", anchor: .center)
            }
        }
    }
}

#if DEBUG

// MARK: - Previews

#Preview {
    JobsPipelineView(
        stream: .init(
            pipelineId: 1,
            projectId: 1,
            sections: [.mock(), .mock(stage: "build")],
            downstreams: [
                .init(
                    pipelineId: 2,
                    projectId: 2,
                    sections: [.mock(), .mock(stage: "build")],
                    downstreams: [

                    ]
                ),
                .init(
                    pipelineId: 3,
                    projectId: 3,
                    sections: [.mock(), .mock(stage: "build")],
                    downstreams: [

                    ]
                )
            ]
        ),
        handleAction: { _ in }
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .gitlabourerBackground()
    .preferredColorScheme(.dark)
}

#endif
