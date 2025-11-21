import Foundation
import ACKategories
import UIKit
import shared
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
            createTabBar(user: nil)
        } else {
            createLoginViewController(
                dependencies: appDependency.loginViewModelDependencies,
                flowDelegate: self
            )
        }

        window.rootViewController = rootVC
        rootViewController = rootVC

        setupAppearance()
    }

    // MARK: - Private helpers

    private func createTabBar(user: User?) -> UITabBarController {
        var fcs: [Base.FlowCoordinatorNoDeepLink] = []

        fcs.append(ProjectsFlowCoordinator())
        fcs.append(MergeRequestsFlowCoordinator())
        fcs.append(
            SettingsFlowCoordinator(
                user: user,
                logoutFlowDelegate: self
            )
        )

        fcs.append(SearchFlowCoordinator())

        fcs.forEach { addChild($0) }

        let tabBarVC = TabBarController()

        tabBarVC.viewControllers = fcs.map {
            $0.start()
        }
        tabBarVC.selectedIndex = 0

        return tabBarVC
    }
}

extension AppFlowCoordinator: LogoutFlowDelegate {
    func logIn(user: User) {
        let rootVC = createTabBar(user: user)

        self.window.rootViewController = rootVC
        rootViewController = rootVC
    }

    func logout() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let rootVC = createLoginViewController(
                dependencies: appDependency.loginViewModelDependencies,
                flowDelegate: self
            )

            self.window.rootViewController = rootVC
            rootViewController = rootVC
        }
    }
}

public protocol LogoutFlowDelegate: AnyObject {
    func logout()
}
