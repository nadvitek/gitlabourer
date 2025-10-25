import Foundation
import ACKategories
import UIKit
import Search
import shared
import ProjectDetail
import MergeRequests
import Repository

final class SearchFlowCoordinator: Base.FlowCoordinatorNoDeepLink, SearchFlowDelegate, ProjectDetailFlowDelegate, MergeRequestsFlowDelegate, RepositoryFlowDelegate {

    override func start() -> UIViewController {
        let vc = createSearchViewController(
            dependencies: appDependency.searchViewModelDependencies,
            flowDelegate: self
        )
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)

        let navVC = UINavigationController(
            rootViewController: vc
        )

        let searchTab = UISearchTab { _ in
            navVC
        }

        navVC.tabBarItem.title = "Search"
        navVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")

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
            let vc = RepositoryView(
                viewModel: RepositoryViewModelImpl(
                    dependencies: appDependency.repositoryViewModelDependencies,
                    flowDelegate: self,
                    projectId: KotlinInt(value: project.id)
                )
            )
            .hosting()

            navigationController?.pushViewController(vc, animated: true)
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
