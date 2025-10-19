import Foundation
import ACKategories
import UIKit
import Projects
import SwiftUI

final class MergeRequestsFlowCoordinator: Base.FlowCoordinatorNoDeepLink {

    override func start() -> UIViewController {
        let navVC = UINavigationController(
            rootViewController: EmptyView().hosting(isTabBarHidden: false)
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
