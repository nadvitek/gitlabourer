package com.jetbrains.kmpapp.core.mapper

import com.jetbrains.kmpapp.core.model.api.ApiPagedResponse
import com.jetbrains.kmpapp.core.model.domain.PageInfo

internal class ApiPagedResponseMapper {

    fun <T> map(api: ApiPagedResponse<T>): PageInfo =
        PageInfo(
            currentPage = api.currentPage,
            nextPage = api.nextPage,
            totalPages = api.totalPages,
            totalItems = api.totalItems,
            perPage = api.perPage
        )

}
