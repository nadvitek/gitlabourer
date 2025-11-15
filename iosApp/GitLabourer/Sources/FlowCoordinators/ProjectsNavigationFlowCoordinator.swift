import Foundation
import Projects
import ProjectDetail
import GitLabourerUI
import shared
import MergeRequests
import Repository
import Pipelines
import ACKategories
import Jobs

class ProjectsNavigationFlowCoordinator: Base.FlowCoordinatorNoDeepLink, ProjectsFlowDelegate, ProjectDetailFlowDelegate, MergeRequestsFlowDelegate, RepositoryFlowDelegate, PipelinesFlowDelegate, JobsFlowDelegate {

    private var projectId: KotlinInt?

    func onProjectClick(_ project: Project) {
        projectId = KotlinInt(value: project.id)

        let vc = ProjectDetailView(
            viewModel: ProjectDetailViewModelImpl(
                project: project,
                flowDelegate: self
            )
        ).hosting()

        navigationController?.pushViewController(vc, animated: true)
    }

    func handleProjectDetailPath(_ path: ProjectDetailPath, project: Project) {
        switch path {
        case .repository:
            let vc = RepositoryView(
                viewModel: RepositoryViewModelImpl(
                    dependencies: appDependency.repositoryViewModelDependencies,
                    flowDelegate: self,
                    project: project
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
            let vc = PipelinesView(
                viewModel: PipelinesViewModelImpl(
                    dependencies: appDependency.pipelinesViewModelDependencies,
                    flowDelegate: self,
                    projectId: KotlinInt(value: project.id)
                )
            )
            .hosting()

            navigationController?.pushViewController(vc, animated: true)

        case .jobs:
            let vc = JobsView(
                viewModel: JobsViewModelImpl(
                    dependencies: appDependency.jobsViewModelDependencies,
                    flowDelegate: self,
                    projectId: KotlinInt(value: project.id),
                    pipelineId: nil,
                    screenType: .list
                )
            )
            .hosting()

            navigationController?.pushViewController(vc, animated: true)

        case .tags:
            break
        }
    }

    func openFile(
        file: TreeItem,
        selectedBranchName: String,
        branches: [String]
    ) {
        guard let projectId else { return }

        let vc = FilesView(
            viewModel: FilesViewModelImpl(
                dependencies: appDependency.filesViewModelDependencies,
                projectId: projectId,
                filePath: file.path,
                selectedBranchName: selectedBranchName,
                branches: branches
            )
        )
        .hosting(supportedOrientations: .landscape)

        vc.overrideUserInterfaceStyle = .dark
        vc.modalPresentationStyle = .fullScreen

        navigationController?.present(vc, animated: true)
    }

    func onPipelineClick(_ pipeline: DetailedPipeline) {
        guard let projectId else { return }

        let vc = JobsView(
            viewModel: JobsViewModelImpl(
                dependencies: appDependency.jobsViewModelDependencies,
                flowDelegate: self,
                projectId: projectId,
                pipelineId: KotlinInt(value: Int32(pipeline.id)),
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
