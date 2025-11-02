import Foundation
import shared
import Projects
import Search
import Login
import Repository
import MergeRequests

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
}
