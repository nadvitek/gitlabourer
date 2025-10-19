import SwiftUI
import GitLabourerUI

public struct ProjectDetailView: View {

    private enum Paths: CaseIterable {
        case repository
        case members
        case mrs
        case pipelines
        case jobs
        case tags

        var text: String {
            switch self {
            case .repository:
                "Repository"
            case .members:
                "Members"
            case .mrs:
                "Merge requests"
            case .pipelines:
                "Pipelines"
            case .jobs:
                "Jobs"
            case .tags:
                "Tags"
            }
        }

        var image: Image {
            switch self {
            case .repository:
                Image(systemName: "folder.fill")
            case .members:
                Image(systemName: "person.2.fill")
            case .mrs:
                Image(systemName: "point.topleft.filled.down.to.point.bottomright.curvepath")
            case .pipelines:
                Image(systemName: "checklist")
            case .jobs:
                Image(systemName: "hammer.fill")
            case .tags:
                Image(systemName: "tag.fill")
            }
        }
    }

    public init() {}
    public var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gitlabourerBackground()
            .preferredColorScheme(.dark)
            .navigationTitle("Oneplay")
    }

    private var content: some View {
        ScrollViewThatFits {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Paths.allCases, id: \.self) { path in
                    Button  {

                    } label: {
                        component(
                            image: path.image,
                            text: path.text
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func component(image: Image, text: String) -> some View {
        HStack(spacing: 12) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)

            Text(text)
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
        .background(GitlabColors.gitlabOrange.swiftUIColor.opacity(0.1))
        .clipShape(.rect(cornerRadius: 16))
//        .border(.red, width: 2)
    }
}

#Preview {
    ProjectDetailView()
}
