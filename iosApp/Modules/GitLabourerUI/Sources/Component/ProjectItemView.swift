import SwiftUI
import shared
import Core

public struct ProjectItemView: View {

    private let project: Project
    private let action: (Project) -> Void

    public init(
        project: Project,
        action: @escaping (Project) -> Void
    ) {
        self.project = project
        self.action = action
    }

    public var body: some View {
        Button {
            action(project)
        } label: {
            content
        }
    }

    private var content: some View {
        HStack(spacing: 8) {
            projectImage

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(project.name)
                        .font(.body)
                        .fontWeight(.semibold)
                        .lineLimit(1)

                    Image(systemName: visibilityName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }

                HStack(spacing: 0) {
                    Text("Maintainer")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundStyle(GitlabColors.gitlabDark.swiftUIColor)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(GitlabColors.gitlabOrangeTwo.swiftUIColor)
                        .clipShape(.rect(cornerRadius: 8))

                    Spacer()

                    HStack(spacing: 2) {
                        Image(systemName: "star")

                        Text(String(Int(project.starCount)))

                        Image(systemName: "tuningfork")

                        Text(String(Int(project.forksCount)))
                    }
                }
            }
            .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)

            Spacer()

            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 10)
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(GitlabColors.gitlabDark.swiftUIColor)
        .clipShape(.rect(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .circular)
                .stroke(GitlabColors.gitlabGray.swiftUIColor.opacity(0.4), lineWidth: 2)

        }
    }

    @ViewBuilder
    private var projectImage: some View {
        if
            let avatarUrl = project.avatarUrl,
            let b64 = avatarUrl.base64,
            let ui = b64.uiImageFromBase64()
        {
            Image(uiImage: ui)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(.rect(cornerRadius: 12))
        } else {
            GitLabourerUIAsset.projectPlaceholder.swiftUIImage
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(.rect(cornerRadius: 12))
        }
    }

    private var visibilityName: String {
        return switch project.visibility {
            case "public": "globe"
            case "internal": "shield.lefthalf.filled"
            case "private": "lock"
            default: "unknown"
        }
    }
}

#if DEBUG

struct ProjectItemView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ProjectItemView(
                project: .mock
            ) { _ in }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gitlabourerBackground()
    }
}

#endif
