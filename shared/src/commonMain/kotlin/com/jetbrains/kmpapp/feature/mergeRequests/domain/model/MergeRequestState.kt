package com.jetbrains.kmpapp.feature.mergeRequests.domain.model

public enum class MergeRequestState(public val value: String) {
    OPENED("opened"),
    MERGED("merged"),
    CLOSED("closed"),
    ALL("all")
}
