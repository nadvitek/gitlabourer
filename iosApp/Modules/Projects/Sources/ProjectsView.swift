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
            .background(GitlabColors.gitlabDark.swiftUIColor)
            .onAppear(perform: viewModel.onAppear)
            .toolbar {
                ToolbarItemTransparent(placement: .topBarLeading) {
                    Text("Projects")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                        .frame(width: 200, alignment: .leading)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: viewModel.logout) {
                        Image(systemName: "door.right.hand.open")
                            .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                    }
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
            ScrollViewThatFits {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(projects, id: \.id) { project in
                        Text(project.name)
                            .font(.title)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                    }
                }
                .padding(.horizontal, 16)
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
}

#if DEBUG

struct ProjectsView_Preview: PreviewProvider {
    static var previews: some View {
        ProjectsView(
            viewModel: ProjectsViewModelMock(
                screenState: .loaded(
                    [
                        .init(
                            id: 0,
                            name: "A",
                            description: nil,
                            webUrl: "",
                            visibility: "",
                            createdAt: "",
                            lastActivityAt: "",
                            namespace: .init(
                                id: 0,
                                name: "",
                                path: ""
                            ),
                            owner: nil
                        )
                    ]
                )
            )
        )
    }
}

#endif
