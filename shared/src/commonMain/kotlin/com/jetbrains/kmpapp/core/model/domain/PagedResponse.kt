package com.jetbrains.kmpapp.core.model.domain

public data class PageInfo(
    val currentPage: Int?,
    val nextPage: Int?,
    val totalPages: Int?,
    val totalItems: Int?,
    val perPage: Int?
) {
    val hasNextPage: Boolean get() = nextPage != null && nextPage != 0
}
