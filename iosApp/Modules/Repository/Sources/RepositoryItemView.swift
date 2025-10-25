import SwiftUI
import shared
import ACKategories
import GitLabourerUI

struct RepositoryItemView: View {

    // MARK: - Properties

    let onRowClick: (TreeItem) -> Void
    let depth: Int
    let item: TreeItem
    let expanded: Set<TreeItem>
    let isFirst: Bool
    let isLast: Bool

    // MARK: - UI

    var body: some View {
        Button {
            onRowClick(item)
        } label: {
            HStack(spacing: 8) {
                if depth > 0 {
                    Color.clear
                        .frame(width: CGFloat(depth) * 16)
                }

                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                    .rotationEffect(.degrees(expanded.contains(item) ? 90 : 0))
                    .foregroundStyle(GitlabColors.gitlabOrangeTwo.swiftUIColor)
                    .opacity(item.kind == .directory ? 1 : 0)

                item.image
                    .foregroundStyle(GitlabColors.gitlabOrangeTwo.swiftUIColor)
                    .frame(width: 20)

                Text(item.name)
                    .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                    .lineLimit(1)

                Spacer()
            }
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(GitlabColors.gitlabDark.swiftUIColor.opacity(0.6))
        .clipShape(
            .rect(
                cornerRadii: .init(
                    topLeading: isFirst ? 12 : 0,
                    bottomLeading: isLast ? 12 : 0,
                    bottomTrailing: isLast ? 12 : 0,
                    topTrailing: isFirst ? 12 : 0
                )
            )
        )
        .overlay {
            UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: isFirst ? 12 : 0,
                    bottomLeading: isLast ? 12 : 0,
                    bottomTrailing: isLast ? 12 : 0,
                    topTrailing: isFirst ? 12 : 0
                )
            )
            .stroke(GitlabColors.gitlabGray.swiftUIColor.opacity(0.35), lineWidth: 1)
        }
        .animation(.default, value: expanded)
        .transition(.slide)
    }
}

#Preview {
    RepositoryItemView(
        onRowClick: { _ in },
        depth: 0,
        item: .init(
            sha: "1",
            name: "1",
            path: "1",
            mode: "223",
            kind: .directory,
            children: []
        ),
        expanded: [],
        isFirst: true,
        isLast: true
    )
}
