import Foundation
import ACKategories
import UIKit
import Login
import Core

final class AppFlowCoordinator: Base.FlowCoordinatorNoDeepLink, LoginFlowDelegate {
    weak var window: UIWindow!

    override func start(
        in window: UIWindow
    ) {
        super.start(in: window)

        self.window = window

        let rootVC = if UserDefaults.standard.isLoggedIn {
            createTabBar()
        } else {
            createLoginViewController(
                dependencies: appDependency.loginViewModelDependencies,
                flowDelegate: self
            )
        }
        window.rootViewController = rootVC
        rootViewController = rootVC
        rootViewController.overrideUserInterfaceStyle = .dark

        setupAppearance()
    }

    // MARK: - Private helpers

    private func createTabBar( ) -> UITabBarController {
        var fcs: [Base.FlowCoordinatorNoDeepLink] = []
        let projects = ProjecstFlowCoordinator()
        let search = SearchFlowCoordinator()

        fcs.append(projects)
        fcs.append(search)

        fcs.forEach { addChild($0) }

        let tabBarVC = UITabBarController()

        tabBarVC.viewControllers = fcs.map {
            $0.start()
        }
        tabBarVC.selectedIndex = 0

        return tabBarVC
    }
}

extension AppFlowCoordinator {
    func logIn() {
        let rootVC = createTabBar()

        self.window.rootViewController = rootVC
        rootViewController = rootVC
        rootViewController.overrideUserInterfaceStyle = .dark
    }
}
