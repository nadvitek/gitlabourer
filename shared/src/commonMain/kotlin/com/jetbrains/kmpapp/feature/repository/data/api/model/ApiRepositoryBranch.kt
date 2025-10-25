package com.jetbrains.kmpapp.feature.repository.data.api.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal class ApiRepositoryBranch(
    @SerialName("name")
    val name: String
)
