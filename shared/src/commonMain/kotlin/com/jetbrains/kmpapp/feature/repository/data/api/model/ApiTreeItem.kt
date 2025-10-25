package com.jetbrains.kmpapp.feature.repository.data.api.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
internal data class ApiTreeItem(
    @SerialName("id")
    val id: String,
    @SerialName("name")
    val name: String,
    @SerialName("path")
    val path: String,
    @SerialName("mode")
    val mode: String,
    @SerialName("type")
    val type: ApiEntryType
)

@Serializable
internal enum class ApiEntryType {
    @SerialName("blob")
    BLOB,
    @SerialName("tree")
    TREE,
    @SerialName("commit")
    COMMIT
}
