package com.jetbrains.kmpapp.feature.repository.domain.usecase

import com.jetbrains.kmpapp.feature.repository.domain.RepositoryRepository
import com.jetbrains.kmpapp.feature.repository.domain.model.RepositoryBranch
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface GetRepositoryBranchesUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(projectId: Int?): List<RepositoryBranch>
}

internal class GetRepositoryBranchesUseCaseImpl(
    private val repositoryRepository: RepositoryRepository
) : GetRepositoryBranchesUseCase {

    override suspend fun invoke(projectId: Int?): List<RepositoryBranch> {
        return repositoryRepository.getRepositoryBranches(projectId)
    }
}
