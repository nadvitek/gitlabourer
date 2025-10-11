import Foundation
import shared

public struct ProjectsViewModelDependencies {
    public let getProjectsUseCase: GetProjectsUseCase
    
    public init(getProjectsUseCase: GetProjectsUseCase) {
        self.getProjectsUseCase = getProjectsUseCase
    }
}
