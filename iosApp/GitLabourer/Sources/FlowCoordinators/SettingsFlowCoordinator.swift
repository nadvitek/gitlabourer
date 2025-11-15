import Foundation
import ACKategories
import UIKit
import SwiftUI
import shared
import Settings

final class SettingsFlowCoordinator: Base.FlowCoordinatorNoDeepLink, SettingsFlowDelegate {

    private let user: User?
    private weak var logoutFlowDelegate: LogoutFlowDelegate?

    init(user: User?, logoutFlowDelegate: LogoutFlowDelegate?) {
        self.user = user
        self.logoutFlowDelegate = logoutFlowDelegate
    }

    override func start() -> UIViewController {
        let vc = SettingsView(
            viewModel: SettingsViewModelImpl(
                flowDelegate: self,
                dependencies: appDependency.settingsViewModelDependencies,
                user: user
            )
        )
        .hosting(isTabBarHidden: false)

        let navVC = UINavigationController(
            rootViewController: vc
        )

        navVC.tabBarItem.title = "Settings"
        navVC.tabBarItem.image = UIImage(systemName: "gearshape")

        navVC.setupCustomBackGestureDelegate()

        parentCoordinator?.navigationController = navVC

        navigationController = navVC
        rootViewController = navVC

        return navVC
    }

    func logout() {
        logoutFlowDelegate?.logout()
    }
}
