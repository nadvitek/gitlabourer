import Foundation
import MergeRequests
import ACKategories
import UIKit
import Projects
import SwiftUI
import shared
import MergeRequestDetail
import Jobs

final class MergeRequestsFlowCoordinator: Base.FlowCoordinatorNoDeepLink, MergeRequestsFlowDelegate, MergeRequestDetailFlowDelegate, JobsFlowDelegate {

    private var projectId: Int64?

    override func start() -> UIViewController {
        let navVC = UINavigationController(
            rootViewController: MergeRequestsView(
                viewModel: MergeRequestsViewModelImpl(
                    dependencies: appDependency.mergeRequestsViewModelDependencies,
                    flowDelegate: self,
                    projectId: nil
                )
            ).hosting(isTabBarHidden: false)
        )

        navVC.tabBarItem.title = "MRs"
        navVC.tabBarItem.image = UIImage(systemName: "point.topleft.filled.down.to.point.bottomright.curvepath")

        navVC.setupCustomBackGestureDelegate()

        parentCoordinator?.navigationController = navVC

        navigationController = navVC
        rootViewController = navVC

        return navVC
    }

    func openMergeRequestDetail(
        projectId: Int64,
        mergeRequestId: Int64
    ) {
        let vc = MergeRequestDetailView(
            viewModel: MergeRequestDetailViewModelImpl(
                dependencies: appDependency.mergeRequestDetailViewModelDependencies,
                flowDelegate: self,
                projectId: projectId,
                mergeRequestId: mergeRequestId
            )
        )
        .hosting()

        self.projectId = projectId

        navigationController?.pushViewController(vc, animated: true)
    }

    func onPipelineClick(_ pipeline: Pipeline) {
        guard let pipelineId = Int32(pipeline.id), let projectId else { return }

        let vc = JobsView(
            viewModel: JobsViewModelImpl(
                dependencies: appDependency.jobsViewModelDependencies,
                flowDelegate: self,
                projectId: projectId,
                pipelineId: KotlinInt(value: pipelineId),
                screenType: .pipeline
            )
        )
        .hosting()

        navigationController?.pushViewController(vc, animated: true)
    }

    func openJob(
        _ job: DetailedJob
    ) {
        guard let projectId else { return }

        let vc = JobsDetailView(
            viewModel: JobsDetailViewModelImpl(
                dependencies: appDependency.jobsDetailViewModelDependencies,
                projectId: projectId,
                job: job
            )
        )
        .hosting(supportedOrientations: .landscape)

        vc.overrideUserInterfaceStyle = .dark
        vc.modalPresentationStyle = .fullScreen

        navigationController?.present(vc, animated: true)
    }
}
