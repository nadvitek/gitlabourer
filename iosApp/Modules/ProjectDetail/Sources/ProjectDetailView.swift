import SwiftUI
import GitLabourerUI

public struct ProjectDetailView<ViewModel: ProjectDetailViewModel>: View {

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
            .preferredColorScheme(.dark)
    }

    // MARK: - Private helpers

    private var content: some View {
        VStack(spacing: 20) {
            HStack(spacing: 8) {
                Text(viewModel.project.name)
                    .font(.title)
                    .fontWeight(.bold)

                projectImage
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            ScrollViewThatFits {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(
                        ProjectDetailSection.allCases,
                        id: \.self
                    ) { section in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(section.title)
                                .font(.title2)
                                .fontWeight(.bold)

                            ForEach(section.paths, id: \.self) { path in
                                pathComponent(path: path)
                            }
                        }
                    }
                }

            }
        }
        .padding(.horizontal, 16)
    }

    private func pathComponent(path: ProjectDetailPath) -> some View {
        Button {
            viewModel.handleProjectDetailPath(path)
        } label: {
            HStack(spacing: 12) {
                path.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)

                Text(path.text)
                    .font(.headline)

                Spacer()

                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
            .padding(12)
            .background(GitlabColors.gitlabOrange.swiftUIColor.opacity(0.05))
            .clipShape(.rect(cornerRadius: 16))
        }
    }

    @ViewBuilder
    private var projectImage: some View {
        if
            let avatarUrl = viewModel.project.avatarUrl,
            let b64 = avatarUrl.base64,
            let ui = b64.uiImageFromBase64()
        {
            Image(uiImage: ui)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(.rect(cornerRadius: 12))
        } else {
            GitLabourerUIAsset.projectPlaceholder.swiftUIImage
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(.rect(cornerRadius: 12))
        }
    }
}

#if DEBUG

// MARK: - Previews

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(
            viewModel: ProjectDetailViewModelMock()
        )
        .preferredColorScheme(.dark)
    }
}

#endif
