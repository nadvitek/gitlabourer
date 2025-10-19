import Foundation
import ACKategories
import UIKit
import Projects

final class ProjecstFlowCoordinator: Base.FlowCoordinatorNoDeepLink, ProjectsFlowDelegate {

    override func start() -> UIViewController {
        let vc = createProjectsViewController(
            dependencies: appDependency.projectsViewModelDependencies,
            flowDelegate: self
        )

        let navVC = UINavigationController(
            rootViewController: vc
        )

        navVC.tabBarItem.title = "Projects"
        navVC.tabBarItem.image = UIImage(systemName: "point.topleft.filled.down.to.point.bottomright.curvepath")

        navVC.setupCustomBackGestureDelegate()

        parentCoordinator?.navigationController = navVC

        navigationController = navVC
        rootViewController = navVC

        return navVC
    }
}
