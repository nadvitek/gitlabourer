import SwiftUI
import shared
import GitLabourerUI
import Core

public struct PipelinesView<ViewModel: PipelinesViewModel>: View {

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
            .toolbar {
                ToolbarItemTransparent(
                    placement: .principal
                ) {
                    Text("Pipelines")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                }
            }
    }

    // MARK: - Private helpers

    @ViewBuilder
    private var content: some View {
        VStack(spacing: 12) {
            switch viewModel.screenState {
            case .loading:
                ProgressView()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
            case .loaded(let array):
                loaded(array)
            }
        }
    }

    private func loaded(_ pipelines: [DetailedPipeline]) -> some View {
        ScrollViewThatFits {
            VStack(spacing: 12) {
                ForEach(pipelines, id: \.id) { pipeline in
                    Button {
                        viewModel.onPipelineClick(pipeline)
                    } label: {
                        pipelineView(pipeline)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func pipelineView(_ pipeline: DetailedPipeline) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                if let name = pipeline.name {
                    HStack(spacing: 0) {
                        Text("Pipeline")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Spacer()

                        Button {
                            viewModel.openLink(pipeline.webUrl)
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
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(height: 43, alignment: .top)
                }
            }


            HStack(alignment: .top, spacing: 0) {
                if let initials = pipeline.user?.name.getNameInitials() {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Author")
                            .font(.title3)
                            .fontWeight(.semibold)

                        userComponent(initials)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Status")
                        .font(.title3)
                        .fontWeight(.semibold)

                    JobStateView(state: pipeline.status)
                        .frame(width: 22, height: 22)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        if let duration = pipeline.durationSeconds {
                            Image(systemName: "clock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)

                            Text(duration.asDurationString())
                                .font(.footnote)
                        }
                    }

                    HStack(spacing: 4) {
                        if let updatedAt = pipeline.updatedAt {
                            Image(systemName: "calendar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)

                            Text(updatedAt.relativeString())
                                .font(.footnote)
                        }
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .bottom
                )
                .padding(.top, 4)
            }
        }
        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(GitlabColors.gitlabOrange.swiftUIColor.opacity(0.5), lineWidth: 4)
        }
        .background(GitlabColors.gitlabOrange.swiftUIColor.opacity(0.05))
        .clipShape(.rect(cornerRadius: 12))
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

#if DEBUG

// MARK: - Previews

#Preview {
    PipelinesView(
        viewModel: PipelinesViewModelMock(
            screenState: .loaded([.mock()])
        )
    )
    .preferredColorScheme(.dark)
}

#endif
