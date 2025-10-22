import Foundation
import ACKategories
import UIKit
import Projects
import ProjectDetail
import GitLabourerUI
import shared
import MergeRequests

final class ProjectsFlowCoordinator: Base.FlowCoordinatorNoDeepLink, ProjectsFlowDelegate, ProjectDetailFlowDelegate, MergeRequestsFlowDelegate {

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

    func handleProjectDetailPath(_ path: ProjectDetailPath, project: Project) {
        switch path {
        case .repository:
            break
        case .members:
            break
        case .mrs:
            let vc = MergeRequestsView(
                viewModel: MergeRequestsViewModelImpl(
                    dependencies: appDependency.mergeRequestsViewModelDependencies,
                    flowDelegate: self,
                    projectId: KotlinInt(value: project.id)
                )
            ).hosting()

            navigationController?.pushViewController(vc, animated: true)
        case .pipelines:
            break
        case .jobs:
            break
        case .tags:
            break
        }
    }
}
