import SwiftUI
import GitLabourerUI
import shared
import ACKategories

struct RepositoryFileTreeView: View {

    let onRowClick: (TreeItem) -> Void
    let assignItemSize: (CGSize) -> Void
    let contentHeight: CGFloat
    let firstLevelItems: [TreeItem]
    let expanded: Set<TreeItem>
    let itemSize: CGSize
    @State private var screenHeight: CGFloat = 0

    // MARK: - UI

    var body: some View {
        VStack(spacing: 0) {
            RepositoryFileTreeLevelView(
                items: firstLevelItems,
                depth: 0,
                maxDepth: 0,
                onRowClick: onRowClick,
                assignItemSize: assignItemSize,
                contentHeight: contentHeight,
                expanded: expanded,
                itemSize: itemSize
            )
        }
        .clipShape(.rect(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(GitlabColors.gitlabGray.swiftUIColor.opacity(0.35), lineWidth: 1)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .readFrame(in: .global) {
            guard screenHeight == 0 else { return }
            screenHeight = $0.height
        }
        .frame(height: screenHeight > contentHeight ? nil : contentHeight, alignment: .top)
    }
}

struct RepositoryFileTreeView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryFileTreeView(
            onRowClick: { _ in },
            assignItemSize: { _ in },
            contentHeight: 0,
            firstLevelItems: [],
            expanded: [],
            itemSize: .zero
        )
    }
}
