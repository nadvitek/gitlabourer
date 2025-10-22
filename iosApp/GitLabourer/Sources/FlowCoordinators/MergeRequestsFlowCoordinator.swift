import Foundation
import MergeRequests
import ACKategories
import UIKit
import Projects
import SwiftUI

final class MergeRequestsFlowCoordinator: Base.FlowCoordinatorNoDeepLink, MergeRequestsFlowDelegate {

    override func start() -> UIViewController {
        let navVC = UINavigationController(
            rootViewController: MergeRequestsView(
                viewModel: MergeRequestsViewModelImpl(
                    dependencies: appDependency.mergeRequestsViewModelDependencies,
                    flowDelegate: self,
                    projectId: nil
                )
            ).hosting(isTabBarHidden: false)
        )

        navVC.tabBarItem.title = "MRs"
        navVC.tabBarItem.image = UIImage(systemName: "point.topleft.filled.down.to.point.bottomright.curvepath")

        navVC.setupCustomBackGestureDelegate()

        parentCoordinator?.navigationController = navVC

        navigationController = navVC
        rootViewController = navVC

        return navVC
    }
}
