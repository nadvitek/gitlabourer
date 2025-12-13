package com.jetbrains.kmpapp.di

import com.jetbrains.kmpapp.feature.apns.apnsModule
import com.jetbrains.kmpapp.feature.apns.domain.GetNotificationsSettingsUseCase
import com.jetbrains.kmpapp.feature.apns.domain.SubscribeForNotificationUseCase
import com.jetbrains.kmpapp.feature.apns.domain.UnsubscribeForNotificationUseCase
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.CancelJobUseCase
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.GetJobLogUseCase
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.GetJobsForPipelineUseCase
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.GetJobsForProjectUseCase
import com.jetbrains.kmpapp.feature.jobs.domain.usecase.RetryJobUseCase
import com.jetbrains.kmpapp.feature.jobs.jobsModule
import com.jetbrains.kmpapp.feature.login.domain.usecase.GetUserUseCase
import com.jetbrains.kmpapp.feature.login.domain.usecase.LoginUseCase
import com.jetbrains.kmpapp.feature.login.domain.usecase.LogoutUseCase
import com.jetbrains.kmpapp.feature.login.loginModule
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.usecase.ChangeMergeRequestApprovalUseCase
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.usecase.GetMergeRequestDetailUseCase
import com.jetbrains.kmpapp.feature.mergeRequestDetail.domain.usecase.MergeMergeRequestUseCase
import com.jetbrains.kmpapp.feature.mergeRequestDetail.mergeRequestDetailModule
import com.jetbrains.kmpapp.feature.mergeRequests.domain.usecase.GetMergeRequestsUseCase
import com.jetbrains.kmpapp.feature.mergeRequests.domain.usecase.GetRepositoryFileTreeUseCase
import com.jetbrains.kmpapp.feature.mergeRequests.mergeRequestsModule
import com.jetbrains.kmpapp.feature.notification.domain.usecase.ObservePipelineUpdatesUseCase
import com.jetbrains.kmpapp.feature.notification.notificationModule
import com.jetbrains.kmpapp.feature.pipelines.domain.usecase.GetPipelinesForProjectUseCase
import com.jetbrains.kmpapp.feature.pipelines.pipelinesModule
import com.jetbrains.kmpapp.feature.project.domain.usecase.GetProjectsUseCase
import com.jetbrains.kmpapp.feature.project.domain.usecase.SearchProjectsUseCase
import com.jetbrains.kmpapp.feature.project.projectModule
import com.jetbrains.kmpapp.feature.repository.domain.usecase.GetFileDataUseCase
import com.jetbrains.kmpapp.feature.repository.domain.usecase.GetRepositoryBranchesUseCase
import com.jetbrains.kmpapp.feature.repository.repositoryDetailModule
import com.jetbrains.kmpapp.feature.token.domain.SaveDeviceTokenUseCase
import com.jetbrains.kmpapp.feature.token.tokenModule
import com.jetbrains.kmpapp.feature.user.userModule
import org.koin.core.component.KoinComponent
import org.koin.core.component.get
import org.koin.core.context.startKoin
import org.koin.core.module.Module

public fun initKoin(extraModules: List<Module>) {
    startKoin {
        modules(
            projectModule,
            repositoryDetailModule,
            tokenModule,
            platformSpecificModule,
            loginModule,
            mergeRequestsModule,
            pipelinesModule,
            jobsModule,
            notificationModule,
            userModule,
            mergeRequestDetailModule,
            apnsModule,
            *extraModules.toTypedArray(),
        )
    }
}

public class AppDependency : KoinComponent {

    public val getProjectsUseCase: GetProjectsUseCase
        get() = get()

    public val loginUseCase: LoginUseCase
        get() = get()

    public val searchProjectsUseCase: SearchProjectsUseCase
        get() = get()

    public val getMergeRequestsUseCase: GetMergeRequestsUseCase
        get() = get()

    public val getRepositoryFileTreeUseCase: GetRepositoryFileTreeUseCase
        get() = get()

    public val getRepositoryBranchesUseCase: GetRepositoryBranchesUseCase
        get() = get()

    public val getFileDataUseCase: GetFileDataUseCase
        get() = get()

    public val getPipelinesForProjectUseCase: GetPipelinesForProjectUseCase
        get() = get()

    public val getJobsForPipelineUseCase: GetJobsForPipelineUseCase
        get() = get()

    public val getJobsForProjectUseCase: GetJobsForProjectUseCase
        get() = get()

    public val cancelJobUseCase: CancelJobUseCase
        get() = get()

    public val retryJobUseCase: RetryJobUseCase
        get() = get()

    public val getJobLogUseCase: GetJobLogUseCase
        get() = get()

    public val logoutUseCase: LogoutUseCase
        get() = get()

    public val getUserUseCase: GetUserUseCase
        get() = get()

    public val observePipelineUpdatesUseCase: ObservePipelineUpdatesUseCase
        get() = get()

    public val getMergeRequestDetailUseCase: GetMergeRequestDetailUseCase
        get() = get()

    public val mergeMergeRequestUseCase: MergeMergeRequestUseCase
        get() = get()

    public val changeMergeRequestApprovalUseCase: ChangeMergeRequestApprovalUseCase
        get() = get()

    public val saveDeviceTokenUseCase: SaveDeviceTokenUseCase
        get() = get()

    public val subscribeForNotificationUseCase: SubscribeForNotificationUseCase
        get() = get()

    public val unsubscribeForNotificationUseCase: UnsubscribeForNotificationUseCase
        get() = get()

    public val getNotificationsSettingsUseCase: GetNotificationsSettingsUseCase
        get() = get()
}
