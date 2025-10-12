import Foundation
import shared
import Projects
import Login

let appDependency = AppDependency()

extension AppDependency {
    var projectsViewModelDependencies: ProjectsViewModelDependencies {
        .init(getProjectsUseCase: appDependency.getProjectsUseCase)
    }

    var loginViewModelDependencies: LoginViewModelDependencies {
        .init(loginUseCase: appDependency.loginUseCase)
    }
}
