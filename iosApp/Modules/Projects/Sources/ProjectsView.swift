import SwiftUI
import GitLabourerUI

public struct ProjectsView<ViewModel: ProjectsViewModel>: View {
    
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
                ToolbarItemTransparent(placement: .topBarLeading) {
                    Text("Projects")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                        .frame(width: 200, alignment: .leading)
                }
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
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(projects, id: \.id) { project in
                        ProjectItemView(
                            project: project,
                            action: viewModel.onProjectClick
                        )
                    }

                    if viewModel.hasNextPage {
                        PrimaryButton(
                            "Load more",
                            isLoading: viewModel.isLoadingNextPage,
                            action: viewModel.loadNextPage
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 16)
                    }
                }
                .padding(.horizontal, 16)
            }
            .refreshable {
                await viewModel.refresh()
            }

        case .error:
            ErrorStateView(
                isLoading: viewModel.isLoading,
                retry: viewModel.retry
            )
        }
    }
}

public func createProjectsViewController(
    dependencies: ProjectsViewModelDependencies,
    flowDelegate: ProjectsFlowDelegate
) -> UIViewController {
    ProjectsView(
        viewModel: ProjectsViewModelImpl(
            dependencies: dependencies,
            flowDelegate: flowDelegate
        )
    )
    .hosting(isTabBarHidden: false)
}

#if DEBUG

// MARK: - Previews

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProjectsView(
                viewModel: ProjectsViewModelMock(
                    screenState: .loaded(
                        [.mock]
                    )
                )
            )
        }
    }
}

#endif
