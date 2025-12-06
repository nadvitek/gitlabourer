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
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gitlabourerBackground()
            .searchable(
                text: $viewModel.text,
                isPresented: $viewModel.isPresented,
                placement: .toolbar,
                prompt: "Search"
            )
            .onAppear {
                viewModel.isPresented = true
            }
            .toolbar {
                ToolbarItemTransparent(placement: .principal) {
                    Text("Search")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                }
            }
            .toolbarVisibility(.visible, for: .navigationBar)
            .animation(.default, value: viewModel.screenState)
    }

    // MARK: - Private helpers

    @ViewBuilder
    private var content: some View {
        VStack(spacing: 12) {
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
                ErrorStateView(
                    isLoading: viewModel.isLoading,
                    retry: viewModel.retry
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
                    ProjectItemView(
                        project: project,
                        action: viewModel.onProjectClick
                    )
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
            dependencies: dependencies,
            flowDelegate: flowDelegate
        )
    )
    .hosting(isTabBarHidden: false)
}

struct SearchViewEmpty_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: SearchViewModelMock(screenState: .loaded([])))
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(
            viewModel: SearchViewModelMock(
                screenState: .loaded([
                    .mock
                ])
            )
        )
    }
}
