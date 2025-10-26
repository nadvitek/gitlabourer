package com.jetbrains.kmpapp.feature.repository.domain.usecase

import com.jetbrains.kmpapp.feature.repository.domain.RepositoryRepository
import com.jetbrains.kmpapp.feature.repository.domain.model.FileData
import io.github.mykhailoliutov.koinexport.core.KoinKmmExport

@KoinKmmExport
public interface GetFileDataUseCase {

    @Throws(Throwable::class)
    public suspend operator fun invoke(
        projectId: Int,
        filePath: String,
        branchName: String
    ): FileData
}

internal class GetFileDataUseCaseImpl(
    private val repositoryRepository: RepositoryRepository
) : GetFileDataUseCase {

    override suspend fun invoke(
        projectId: Int,
        filePath: String,
        branchName: String
    ): FileData {
        return repositoryRepository.getFileData(projectId, filePath, branchName)
    }
}
