import Foundation
import shared
import Projects

let appDependency = AppDependency()

extension AppDependency {
    var projectsViewModelDependencies: ProjectsViewModelDependencies {
        .init(getProjectsUseCase: appDependency.getProjectsUseCase)
    }
}
