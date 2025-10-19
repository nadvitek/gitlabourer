import Foundation
import ACKategories
import UIKit
import Search

final class SearchFlowCoordinator: Base.FlowCoordinatorNoDeepLink, SearchFlowDelegate {

    override func start() -> UIViewController {
        let vc = createSearchViewController(
            dependencies: appDependency.searchViewModelDependencies,
            flowDelegate: self
        )
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)

        let navVC = UINavigationController(
            rootViewController: vc
        )

        let searchTab = UISearchTab { _ in
            navVC
        }

        navVC.tabBarItem.title = "Search"
        navVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")

        navVC.setupCustomBackGestureDelegate()

        parentCoordinator?.navigationController = navVC

        navigationController = navVC
        rootViewController = navVC

        return navVC
    }
}
