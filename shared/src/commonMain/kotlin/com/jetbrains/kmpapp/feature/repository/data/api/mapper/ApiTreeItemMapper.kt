package com.jetbrains.kmpapp.feature.repository.data.api.mapper

import com.jetbrains.kmpapp.feature.repository.data.api.model.ApiEntryType
import com.jetbrains.kmpapp.feature.repository.data.api.model.ApiTreeItem
import com.jetbrains.kmpapp.feature.repository.domain.model.TreeItem

internal class ApiRepositoryTreeMapper {

    fun map(api: ApiTreeItem): TreeItem = TreeItem(
        sha = api.id,
        name = api.name,
        path = api.path,
        mode = api.mode,
        kind = api.type.toKind()
    )

    fun map(list: List<ApiTreeItem>): List<TreeItem> = list.map(::map)

    private fun ApiEntryType?.toKind(): TreeItem.Kind = when (this) {
        ApiEntryType.BLOB -> TreeItem.Kind.FILE
        ApiEntryType.TREE -> TreeItem.Kind.DIRECTORY
        ApiEntryType.COMMIT -> TreeItem.Kind.SUBMODULE
        null -> TreeItem.Kind.FILE
    }
}
