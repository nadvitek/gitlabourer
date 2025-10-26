package com.jetbrains.kmpapp.feature.repository.data.api.mapper

import com.jetbrains.kmpapp.feature.repository.data.api.model.ApiFileData
import com.jetbrains.kmpapp.feature.repository.domain.model.FileData

internal class ApiFileDataMapper {

    fun map(api: ApiFileData): FileData = FileData(
        fileName = api.fileName,
        ref = api.ref,
        content = api.content
    )
}
