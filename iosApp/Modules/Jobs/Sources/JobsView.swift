import SwiftUI
import GitLabourerUI
import shared

public struct JobsView<ViewModel: JobsViewModel>: View {

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
                    Text("Jobs")
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
            case let .list(list):
                JobsListView(list: list, handleAction: viewModel.handleAction)

            case let .pipeline(stream):
                JobsPipelineView(stream: stream, handleAction: viewModel.handleAction)
            }
        }
    }
}

#if DEBUG

// MARK: - Previews

#Preview {
    JobsView(viewModel: JobsViewModelMock())
        .preferredColorScheme(.dark)
}

#endif
