import Foundation
import shared
import Projects
import Search
import Login
import Repository
import MergeRequests
import Pipelines
import Jobs
import Settings

let appDependency = AppDependency()

extension AppDependency {
    var projectsViewModelDependencies: ProjectsViewModelDependencies {
        .init(getProjectsUseCase: appDependency.getProjectsUseCase)
    }

    var loginViewModelDependencies: LoginViewModelDependencies {
        .init(loginUseCase: appDependency.loginUseCase)
    }

    var searchViewModelDependencies: SearchViewModelDependencies {
        .init(searchProjectsUseCase: appDependency.searchProjectsUseCase)
    }

    var mergeRequestsViewModelDependencies: MergeRequestsViewModelDependencies {
        .init(getMergeRequestsUseCase: appDependency.getMergeRequestsUseCase)
    }

    var repositoryViewModelDependencies: RepositoryViewModelDependencies {
        .init(
            getRepositoryFileTreeUseCase: appDependency.getRepositoryFileTreeUseCase,
            getRepositoryBranchesUseCase: appDependency.getRepositoryBranchesUseCase
        )
    }

    var filesViewModelDependencies: FilesViewModelDependencies {
        .init(
            getFileData: appDependency.getFileDataUseCase
        )
    }

    var pipelinesViewModelDependencies: PipelinesViewModelDependencies {
        .init(
            getPipelinesForProjectUseCase: appDependency.getPipelinesForProjectUseCase
        )
    }

    var jobsViewModelDependencies: JobsViewModelDependencies {
        JobsViewModelDependencies(
            getJobsForProjectUseCase: appDependency.getJobsForProjectUseCase,
            getJobsForPipelineUseCase: appDependency.getJobsForPipelineUseCase,
            cancelJobUseCase: appDependency.cancelJobUseCase,
            retryJobUseCase: appDependency.retryJobUseCase
        )
    }

    var jobsDetailViewModelDependencies: JobsDetailViewModelDependencies {
        JobsDetailViewModelDependencies(
            cancelJobUseCase: appDependency.cancelJobUseCase,
            retryJobUseCase: appDependency.retryJobUseCase,
            getJobLogUseCase: appDependency.getJobLogUseCase
        )
    }

    var settingsViewModelDependencies: SettingsViewModelDependencies {
        SettingsViewModelDependencies(
            getUserUseCase: getUserUseCase,
            logoutUseCase: logoutUseCase
        )
    }
}
