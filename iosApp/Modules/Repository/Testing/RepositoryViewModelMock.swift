import Foundation
import shared
import SwiftUI

final class RepositoryViewModelMock: RepositoryViewModel {
    var screenState: RepositoryScreenState

    var expanded: Set<TreeItem> = []
    var scrollViewAxes: Axis.Set {
        expanded.isEmpty ? [.vertical] : [.vertical, .horizontal]
    }
    var itemSize: CGSize = .zero
    var contentHeight: Double {
        let count = Double(visibleItems)
        return count * itemSize.height
    }
    var visibleItems: Int {
        itemCount + expanded.map(\.children).count
    }
    var itemCount: Int = 0
    var branches: [String] = [
        "development",
        "feature/rosta",
        "fix/verca"
    ]
    var selectedBranchName: String = "development"

    init(screenState: RepositoryScreenState = .loading) {
        self.screenState = screenState
        if case let .loaded(items) = screenState {
            itemCount = items.count
        }
    }

    func onAppear() {}
    func onRowClick(_ item: TreeItem) {}
    func assignItemSize(_ size: CGSize) {}
}
