import SwiftUI
import GitLabourerUI
import shared

struct ProjectItemView: View {

    let project: Project

    var body: some View {
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

extension String {
    func uiImageFromBase64() -> UIImage? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return UIImage(data: data)
    }
}

#if DEBUG

#Preview {
    VStack(spacing: 20) {
        ProjectItemView(
            project: .mock
        )
    }
    .padding(.horizontal)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .gitlabourerBackground()
}

extension Project {
    static var mock: Project {
        Project(
            id: 1944,
            name: "Oneplay Mobile app",
            description: "",
            webUrl: "https://gitlab.ack.ee/ebox/mobile-app",
            visibility: "public",
            avatarUrl: nil,
            starCount: 3,
            forksCount: 0,
            createdAt: "2025-03-15T09:02:49.348Z",
            lastActivityAt: "2025-10-12T08:16:28.978Z",
            namespace: Namespace(id: 2062, name: "ebox", path: "ebox"),
            owner: nil
        )
    }
}

#endif
