import SwiftUI
import shared

struct RepositoryFileTreeLevelView: View {

    let items: [TreeItem]
    let depth: Int
    let maxDepth: Int
    let onRowClick: (TreeItem) -> Void
    let assignItemSize: (CGSize) -> Void
    let contentHeight: CGFloat
    let expanded: Set<TreeItem>
    let itemSize: CGSize

    var body: some View {
        ForEach(items, id:\.self) { item in
            let isFirst = items.first == item
            let isLast = items.last == item
            let hasVisibleChildren = item.kind == .directory && expanded.contains(item)

            RepositoryItemView(
                onRowClick: onRowClick,
                depth: depth,
                item: item,
                expanded: expanded,
                isFirst: isFirst && depth == 0,
                isLast: isLast && depth == 0
            )
            .readSize {
                guard
                    depth == 0,
                    itemSize == .zero
                else { return }

                assignItemSize($0)
            }
            .frame(minWidth: itemSize.width)
//            .frame(
//                width: hasVisibleChildren ? (itemSize.width + CGFloat(depth * 16)) : nil
//            )

            if hasVisibleChildren {
                RepositoryFileTreeLevelView(
                    items: item.children,
                    depth: depth + 1,
                    maxDepth: maxDepth,
                    onRowClick: onRowClick,
                    assignItemSize: assignItemSize,
                    contentHeight: contentHeight,
                    expanded: expanded,
                    itemSize: itemSize
                )
            }
        }
    }
}
