import SwiftUI
import GitLabourerUI
import shared

public struct SearchView<ViewModel: SearchViewModel>: View {
    @FocusState private var focused: Bool

    // MARK: - Properties

    @State private var viewModel: ViewModel

    // MARK: - Initializers

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - UI

    public var body: some View {
        NavigationStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .gitlabourerBackground()
                .searchable(
                    text: $viewModel.text,
                    isPresented: $viewModel.isPresented,
                    placement: .sidebar,
                    prompt: "Search"
                )
//                .focusable(true)
//                .searchFocused($focused)
                .onAppear {
                    viewModel.isPresented = true
                }
                .animation(.default, value: viewModel.screenState)
        }
    }

    // MARK: - Private helpers

    @ViewBuilder
    private var content: some View {
        switch viewModel.screenState {
        case .loading:
            ProgressView()
                .tint(.white)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
        case let .loaded(projects):
            ScrollViewThatFits {
                loadedState(projects)
            }
        case .error:
            VStack(spacing: 20) {
                Image(systemName: "network.slash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                    .symbolEffect(.bounce)

                PrimaryButton(
                    "Retry",
                    isLoading: viewModel.isLoading,
                    action: viewModel.retry
                )
            }
        }
    }

    @ViewBuilder
    private func loadedState(_ projects: [Project]) -> some View {
        if projects.isEmpty {
            ContentUnavailableView.search
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                .padding(.top, 100)
        } else {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(projects, id: \.id) { project in
                    ProjectItemView(project: project)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

public func createSearchViewController(
    dependencies: SearchViewModelDependencies,
    flowDelegate: SearchFlowDelegate
) -> UIViewController {
    SearchView(
        viewModel: SearchViewModelImpl(
            dependencies: dependencies
        )
    )
    .hosting(isTabBarHidden: false)
}

#Preview {
    SearchView(viewModel: SearchViewModelMock(screenState: .loaded([])))
}
