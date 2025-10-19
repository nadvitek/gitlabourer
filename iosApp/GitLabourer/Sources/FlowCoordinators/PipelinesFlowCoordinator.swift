import Foundation
import SwiftUI
import ACKategories
import UIKit
import Projects

final class PipelinesFlowCoordinator: Base.FlowCoordinatorNoDeepLink {

    override func start() -> UIViewController {
        let navVC = UINavigationController(
            rootViewController: EmptyView().hosting(isTabBarHidden: false)
        )

        navVC.tabBarItem.title = "Pipelines"
        navVC.tabBarItem.image = UIImage(systemName: "checklist")

        navVC.setupCustomBackGestureDelegate()

        parentCoordinator?.navigationController = navVC

        navigationController = navVC
        rootViewController = navVC

        return navVC
    }
}
