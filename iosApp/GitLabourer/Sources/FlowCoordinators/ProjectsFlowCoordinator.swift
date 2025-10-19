import Foundation
import ACKategories
import UIKit
import Projects
import ProjectDetail
import GitLabourerUI
import shared

final class ProjectsFlowCoordinator: Base.FlowCoordinatorNoDeepLink, ProjectsFlowDelegate, ProjectDetailFlowDelegate {

    override func start() -> UIViewController {
        let vc = createProjectsViewController(
            dependencies: appDependency.projectsViewModelDependencies,
            flowDelegate: self
        )

        let navVC = UINavigationController(
            rootViewController: vc
        )

        navVC.tabBarItem.title = "Projects"
        navVC.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle")

        navVC.setupCustomBackGestureDelegate()

        parentCoordinator?.navigationController = navVC

        navigationController = navVC
        rootViewController = navVC

        return navVC
    }

    func onProjectClick(_ project: Project) {
        let vc = ProjectDetailView(
            viewModel: ProjectDetailViewModelImpl(
                project: project,
                flowDelegate: self
            )
        ).hosting(isTabBarHidden: false)

        navigationController?.pushViewController(vc, animated: true)
    }

    func handleProjectDetailPath(_ path: ProjectDetailPath) {
        switch path {
        case .repository:
            break
        case .members:
            break
        case .mrs:
            break
        case .pipelines:
            break
        case .jobs:
            break
        case .tags:
            break
        }
    }
}
