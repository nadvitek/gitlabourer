import Foundation
import ACKategories
import UIKit
import Projects
import SwiftUI

final class SettingsFlowCoordinator: Base.FlowCoordinatorNoDeepLink {

    override func start() -> UIViewController {
        let navVC = UINavigationController(
            rootViewController: EmptyView().hosting(isTabBarHidden: false)
        )

        navVC.tabBarItem.title = "Settings"
        navVC.tabBarItem.image = UIImage(systemName: "gearshape")

        navVC.setupCustomBackGestureDelegate()

        parentCoordinator?.navigationController = navVC

        navigationController = navVC
        rootViewController = navVC

        return navVC
    }
}
