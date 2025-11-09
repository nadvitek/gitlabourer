import Foundation
import shared
import Observation
import SwiftUI

// MARK: - JobsViewModel

public protocol JobsViewModel {
    var screenState: JobsScreenState { get }

    func onAppear()
    func openLink(_ webUrl: String)
    func handleAction(_ action: JobsAction)
}

// MARK: - ScreenState

public enum JobsScreenState {
    case loading
    case list([DetailedJob])
    case pipeline(JobsStream)
}

public enum JobsScreenType {
    case pipeline
    case list
}

public enum JobsAction {
    case retry(DetailedJob)
    case cancel(DetailedJob)
    case open(DetailedJob)
}

// MARK: - JobsViewModelImpl

@Observable
public class JobsViewModelImpl: JobsViewModel {

    // MARK: - Internal properties

    public var screenState: JobsScreenState = .loading

    private let projectId: KotlinInt
    private let dependencies: JobsViewModelDependencies
    private weak var flowDelegate: JobsFlowDelegate?
    private let pipelineId: KotlinInt?
    private var pageNumber: Int = 0
    private let jobsScreenType: JobsScreenType

    // MARK: - Initializers

    public init(
        dependencies: JobsViewModelDependencies,
        flowDelegate: JobsFlowDelegate?,
        projectId: KotlinInt,
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
                    projectId: Int32(truncating: projectId),
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

            }
        }
    }

    private func loadListData() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                let jobs = try await dependencies.getJobsForProjectUseCase.invoke(
                    projectId: Int32(truncating: projectId),
                    pageNumber: Int32(pageNumber)
                )

                screenState = .list(jobs)
            } catch {

            }
        }
    }

    private func retryJob(_ job: DetailedJob) {
        Task { [weak self] in
            guard let self else { return }

            do {
                try await dependencies.retryJobUseCase.invoke(
                    projectId: Int32(truncating: projectId),
                    jobId: job.id
                )
            } catch {

            }
        }
    }

    private func cancelJob(_ job: DetailedJob) {
        Task { [weak self] in
            guard let self else { return }

            do {
                try await dependencies.cancelJobUseCase.invoke(
                    projectId: Int32(truncating: projectId),
                    jobId: job.id
                )
            } catch {

            }
        }
    }
}
