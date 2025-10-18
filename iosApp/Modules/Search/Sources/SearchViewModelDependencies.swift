import Foundation
import shared

public struct SearchViewModelDependencies {
    public let searchProjectsUseCase: SearchProjectsUseCase

    public init(searchProjectsUseCase: SearchProjectsUseCase) {
        self.searchProjectsUseCase = searchProjectsUseCase
    }
}
