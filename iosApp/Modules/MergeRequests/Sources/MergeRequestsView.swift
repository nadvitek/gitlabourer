import SwiftUI
import GitLabourerUI
import Core
import shared

public struct MergeRequestsView<ViewModel: MergeRequestsViewModel>: View {

    // MARK: - Properties

    @State private var viewModel: ViewModel

    // MARK: - Initializers

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                ForEach(MergeRequestState.allCases, id: \.self) { state in
                    stateButton(state)
                }
            }

            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gitlabourerBackground()
        .onAppear(perform: viewModel.onAppear)
        .toolbar {
            ToolbarItemTransparent(placement: .principal) {
                Text("Merge Requests")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
            }
        }
    }

    // MARK: - Private helpers

    private var content: some View {
        ScrollViewThatFits {
            switch viewModel.screenState[viewModel.selectedState] {
            case let .loaded(mrs):
                VStack(spacing: 16) {
                    ForEach(mrs, id:\.self) { mr in
                        MergeRequestItemView(mr: mr)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 1)
            case .loading, .none:
                ProgressView()
            }
        }
        .onAppear(perform: viewModel.onAppear)
    }

    private func stateButton(_ state: MergeRequestState) -> some View {
        Button {
            viewModel.selectState(state: state)
        } label: {
            Text(state.title)
                .fontWeight(.semibold)
                .font(.headline)
                .foregroundStyle(viewModel.isStateSelected(state) ? GitlabColors.gitlabDark.swiftUIColor : GitlabColors.gitlabDark.swiftUIColor)
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(viewModel.isStateSelected(state) ? GitlabColors.gitlabOrangeTwo.swiftUIColor : GitlabColors.gitlabGray.swiftUIColor.opacity(0.8))
                .clipShape(.rect(cornerRadius: 16))
        }
    }

    private func stateButtonNew(_ state: MergeRequestState) -> some View {
        Button {
            viewModel.selectState(state: state)
        } label: {
            VStack(spacing: 2) {
                Text(state.title)
                    .fontWeight(.semibold)
                    .font(.headline)
                    .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)

                if viewModel.isStateSelected(state) {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(height: 5)
                        .foregroundStyle(GitlabColors.gitlabOrange.swiftUIColor)
                } else {
                    Color.clear
                        .frame(height: 5)
                }
            }
        }
        .animation(.bouncy, value: viewModel.selectedState)
    }
}

#Preview {
    MergeRequestsView(
        viewModel: MergeRequestsViewModelMock(
            screenState: .loaded(
                MergeRequestMockFactory.makeList()
            )
        )
    )
    .preferredColorScheme(.dark)
}
