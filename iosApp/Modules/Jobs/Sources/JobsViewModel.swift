import Foundation
import shared
import Observation
import SwiftUI

// MARK: - JobsViewModel

public protocol JobsViewModel {
    var screenState: JobsScreenState { get }
    var isLoadingNextPage: Bool { get }
    var hasNextPage: Bool { get }
    var isRetryLoading: Bool { get }

    func onAppear()
    func openLink(_ webUrl: String)
    func retry()
    func refresh() async
    func handleAction(_ action: JobsAction)
}

// MARK: - ScreenState

public enum JobsScreenState {
    case loading
    case list([DetailedJob])
    case pipeline(JobsStream)
    case error
}

public enum JobsScreenType {
    case pipeline
    case list
}

public enum JobsAction {
    case retry(DetailedJob)
    case cancel(DetailedJob)
    case open(DetailedJob)
    case loadNextPage
    case openLink(String?)
}

// MARK: - JobsViewModelImpl

@Observable
public class JobsViewModelImpl: JobsViewModel {

    // MARK: - Internal properties

    public var screenState: JobsScreenState = .loading
    public var hasNextPage: Bool = false
    public var isLoadingNextPage: Bool = false
    public var isRetryLoading: Bool = false

    private let projectId: Int64
    private let dependencies: JobsViewModelDependencies
    private weak var flowDelegate: JobsFlowDelegate?
    private let pipelineId: KotlinInt?
    private var pageNumber: Int = 1
    private let jobsScreenType: JobsScreenType
    private var cachedJobs: [DetailedJob] = []

    // MARK: - Initializers

    public init(
        dependencies: JobsViewModelDependencies,
        flowDelegate: JobsFlowDelegate?,
        projectId: Int64,
        pipelineId: KotlinInt?,
        screenType: JobsScreenType
    ) {
        self.dependencies = dependencies
        self.flowDelegate = flowDelegate
        self.projectId = projectId
        self.pipelineId = pipelineId
        self.jobsScreenType = screenType
    }

    // MARK: - Internal interface

    public func onAppear() {
        guard case .loading = screenState else { return }

        switch jobsScreenType {
        case .pipeline:
            loadPipelineData()

        case .list:
            loadListData()
        }
    }

    public func openLink(_ webUrl: String) {
        guard
            let url = URL(string: webUrl),
            UIApplication.shared.canOpenURL(url)
        else { return }

        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    public func handleAction(_ action: JobsAction) {
        switch action {
        case let .cancel(job):
            cancelJob(job)

        case let .retry(job):
            retryJob(job)

        case let .open(job):
            flowDelegate?.openJob(job)

        case .loadNextPage:
            loadNextPage()

        case let .openLink(url):
            if let url {
                openLink(url)
            }
        }
    }

    public func retry() {
        isRetryLoading = true

        switch jobsScreenType {
        case .pipeline:
            loadPipelineData()

        case .list:
            loadListData()
        }
    }

    public func refresh() async {
        cachedJobs = []
        pageNumber = 1

        do {
            let jobs = try await dependencies.getJobsForProjectUseCase.invoke(
                projectId: Int32(projectId),
                pageNumber: Int32(pageNumber)
            )

            cachedJobs = jobs.items
            hasNextPage = jobs.pageInfo.hasNextPage
            screenState = .list(jobs.items)
        } catch {
            screenState = .error
        }
    }

    // MARK: - Private helpers

    private func loadPipelineData() {
        Task { @MainActor [weak self] in
            guard
                let self,
                let pipelineId
            else { return }

            do {
                let stream = try await dependencies.getJobsForPipelineUseCase.invoke(
                    projectId: Int32(projectId),
                    pipelineId: Int64(truncating: pipelineId)
                )

                screenState = .pipeline(stream)

                stream.downstreams.forEach { str in
                    print(str.sections)

                    str.downstreams.forEach {
                        print($0.sections)
                    }
                }
            } catch {
                screenState = .error
            }
        }
    }

    private func loadListData() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                let jobs = try await dependencies.getJobsForProjectUseCase.invoke(
                    projectId: Int32(projectId),
                    pageNumber: Int32(pageNumber)
                )

                cachedJobs = jobs.items
                hasNextPage = jobs.pageInfo.hasNextPage
                screenState = .list(jobs.items)
            } catch {
                screenState = .error
            }
        }
    }

    private func loadNextPage() {
        pageNumber += 1

        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                let jobs = try await dependencies.getJobsForProjectUseCase.invoke(
                    projectId: Int32(projectId),
                    pageNumber: Int32(pageNumber)
                )

                cachedJobs.append(contentsOf: jobs.items)
                hasNextPage = jobs.pageInfo.hasNextPage
                screenState = .list(cachedJobs)
            } catch {
                screenState = .error
            }
        }
    }

    private func retryJob(_ job: DetailedJob) {
        Task { [weak self] in
            guard let self else { return }

            let _ = try? await dependencies.retryJobUseCase.invoke(
                projectId: Int32(projectId),
                jobId: job.id
            )
        }
    }

    private func cancelJob(_ job: DetailedJob) {
        Task { [weak self] in
            guard let self else { return }

            let _ = try? await dependencies.cancelJobUseCase.invoke(
                projectId: Int32(projectId),
                jobId: job.id
            )
        }
    }
}
