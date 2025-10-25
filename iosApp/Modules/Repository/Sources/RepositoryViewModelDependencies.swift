import Foundation
import shared

public struct RepositoryViewModelDependencies {
    public let getRepositoryFileTreeUseCase: GetRepositoryFileTreeUseCase
    public let getRepositoryBranchesUseCase: GetRepositoryBranchesUseCase

    public init(
        getRepositoryFileTreeUseCase: GetRepositoryFileTreeUseCase,
        getRepositoryBranchesUseCase: GetRepositoryBranchesUseCase
    ) {
        self.getRepositoryFileTreeUseCase = getRepositoryFileTreeUseCase
        self.getRepositoryBranchesUseCase = getRepositoryBranchesUseCase
    }
}
