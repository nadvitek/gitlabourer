package com.jetbrains.kmpapp.feature.mergeRequests.domain.usecase

import com.jetbrains.kmpapp.feature.mergeRequests.domain.MergeRequestsRepository
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequest
import com.jetbrains.kmpapp.feature.mergeRequests.domain.model.MergeRequestState
import com.jetbrains.kmpapp.feature.repository.domain.RepositoryRepository
import com.jetbrains.kmpapp.feature.repository.domain.model.TreeItem

import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface GetRepositoryFileTreeUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(projectId: Int?, branchName: String?): List<TreeItem>
}

internal class GetRepositoryFileTreeUseCaseImpl(
    private val repositoryRepository: RepositoryRepository
) : GetRepositoryFileTreeUseCase {

    override suspend fun invoke(projectId: Int?, branchName: String?): List<TreeItem> {
        return repositoryRepository.getRepositoryTree(projectId, branchName)
    }
}
