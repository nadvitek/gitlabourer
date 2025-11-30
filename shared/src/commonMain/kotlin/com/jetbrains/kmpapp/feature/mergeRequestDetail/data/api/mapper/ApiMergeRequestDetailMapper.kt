package com.jetbrains.kmpapp.feature.mergeRequestDetail.data.api.mapper

import com.jetbrains.kmpapp.feature.login.data.api.mapper.ApiUserMapper
import com.jetbrains.kmpapp.feature.mergeRequestDetail.data.api.model.ApiMergeRequestDetail
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.model.MergeRequestDetail
import com.jetbrains.kmpapp.feature.mergeRequests.data.api.mapper.ApiPipelineMapper
import com.jetbrains.kmpapp.feature.mergerequest.data.api.mapper.ApiMergeRequestMapper

internal class ApiMergeRequestDetailMapper {

    private val apiUserMapper = ApiUserMapper()
    private val apiMergeRequestMapper = ApiMergeRequestMapper()
    private val apiPipelineMapper = ApiPipelineMapper()

    fun map(api: ApiMergeRequestDetail): MergeRequestDetail =
        MergeRequestDetail(
            id = api.id,
            iid = api.iid,
            projectId = api.projectId,
            title = api.title,
            description = api.description,
            assignee = api.assignee?.let(apiUserMapper::map),
            reviewers = api.reviewers.map(apiUserMapper::map),
            webUrl = api.webUrl,
            sourceBranch = api.sourceBranch,
            targetBranch = api.targetBranch,
            state = apiMergeRequestMapper.mapState(api.state),
            approved = api.approved ?: false,
            changesCount = api.changesCount,
            pipeline = api.pipeline?.let(apiPipelineMapper::map),
            canMerge = api.user?.canMerge ?: true
        )
}
