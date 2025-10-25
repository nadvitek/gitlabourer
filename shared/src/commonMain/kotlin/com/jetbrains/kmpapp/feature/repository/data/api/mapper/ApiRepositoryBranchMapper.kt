package com.jetbrains.kmpapp.feature.repository.data.api.mapper

import com.jetbrains.kmpapp.feature.repository.data.api.model.ApiRepositoryBranch
import com.jetbrains.kmpapp.feature.repository.domain.model.RepositoryBranch

internal class ApiRepositoryBranchMapper {

    fun map(apiRepositoryBranch: ApiRepositoryBranch): RepositoryBranch =
        RepositoryBranch(
            name = apiRepositoryBranch.name
        )
}
