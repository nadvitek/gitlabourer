package com.jetbrains.kmpapp.core.model.api

public data class ApiPagedResponse<T>(
    val response: T,
    val currentPage: Int?,
    val nextPage: Int?,
    val totalPages: Int?,
    val totalItems: Int?,
    val perPage: Int?
)
