import Foundation
import shared

public struct RepositoryViewModelDependencies {
    public let getRepositoryFileTreeUseCase: GetRepositoryFileTreeUseCase

    public init(getRepositoryFileTreeUseCase: GetRepositoryFileTreeUseCase) {
        self.getRepositoryFileTreeUseCase = getRepositoryFileTreeUseCase
    }
}
