import SwiftUI
import GitLabourerUI
import shared
import ACKategories

public struct RepositoryView<ViewModel: RepositoryViewModel>: View {

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
                    Text("Repository")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        VStack(spacing: 0) {
            RepositoryBranchPickerView(
                selectedBranch: $viewModel.selectedBranchName,
                branches: viewModel.branches
            )
            .disabled(viewModel.branches.isEmpty)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)

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

    private func loaded(_ array: [TreeItem]) -> some View {
        ScrollView(viewModel.scrollViewAxes) {
            RepositoryFileTreeView(
                onRowClick: viewModel.onRowClick,
                assignItemSize: viewModel.assignItemSize,
                contentHeight: viewModel.contentHeight,
                firstLevelItems: array,
                expanded: viewModel.expanded,
                itemSize: viewModel.itemSize
            )
        }
    }
}

// MARK: - Extensions

extension TreeItem {
    var swiftChildren: [TreeItem]? {
        return children.isEmpty ? nil : children
    }

    var image: Image {
        switch kind {
        case .directory:
            Image(systemName: "folder.fill")
        case .file:
            Image(systemName: "doc.text")
        case .submodule:
            Image(systemName: "link")
        default:
            Image(systemName: "doc.text")
        }
    }
}

#Preview {
    RepositoryView(
        viewModel: RepositoryViewModelMock(
            screenState: .loaded(
                [
                    .init(
                        sha: "1",
                        name: "File",
                        path: "1",
                        mode: "1",
                        kind: .file,
                        children: []
                    ),
                    .init(
                        sha: "2",
                        name: "Directory",
                        path: "2",
                        mode: "2",
                        kind: .directory,
                        children: [
                            .init(
                                sha: "4",
                                name: "File",
                                path: "1",
                                mode: "1",
                                kind: .file,
                                children: []
                            ),
                            .init(
                                sha: "5",
                                name: "Subdir",
                                path: "2/5",
                                mode: "2",
                                kind: .directory,
                                children: [
                                    .init(
                                        sha: "6",
                                        name: "Nested file",
                                        path: "2/5/6",
                                        mode: "1",
                                        kind: .file,
                                        children: []
                                    )
                                ]
                            )
                        ]
                    ),
                    .init(
                        sha: "3",
                        name: "Submodule",
                        path: "2",
                        mode: "2",
                        kind: .submodule,
                        children: []
                    )
                ]
            )
        )
    )
    .preferredColorScheme(.dark)
}
