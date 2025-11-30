import Foundation
import shared
import Observation
import SwiftUI

// MARK: - PipelinesViewModel

public protocol PipelinesViewModel {
    var screenState: PipelinesScreenState { get }
    var hasNextPage: Bool { get }
    var isRetryLoading: Bool { get }
    var isLoadingNextPage: Bool { get }

    func onAppear()
    func openLink(_ webUrl: String)
    func refresh() async
    func retry()
    func loadNextPage()
    func onPipelineClick(_ pipeline: DetailedPipeline)
}

// MARK: - ScreenState

public enum PipelinesScreenState {
    case loading
    case loaded([DetailedPipeline])
    case error
}

// MARK: - PipelinesViewModelImpl

@Observable
public class PipelinesViewModelImpl: PipelinesViewModel {

    // MARK: - Internal properties

    public var screenState: PipelinesScreenState = .loading
    public var hasNextPage: Bool = false
    public var isRetryLoading: Bool = false
    public var isLoadingNextPage: Bool = false

    private let projectId: KotlinInt
    private var cachedPipelines: [DetailedPipeline] = []
    private let dependencies: PipelinesViewModelDependencies
    private weak var flowDelegate: PipelinesFlowDelegate?
    private var pageNumber: Int = 1

    // MARK: - Initializers

    public init(
        dependencies: PipelinesViewModelDependencies,
        flowDelegate: PipelinesFlowDelegate?,
        projectId: KotlinInt,
    ) {
        self.dependencies = dependencies
        self.flowDelegate = flowDelegate
        self.projectId = projectId
    }

    // MARK: - Internal interface

    public func onAppear() {
        guard case .loading = screenState else { return }

        loadData()
    }

    public func openLink(_ webUrl: String) {
        guard
            let url = URL(string: webUrl),
            UIApplication.shared.canOpenURL(url)
        else { return }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    public func onPipelineClick(_ pipeline: DetailedPipeline) {
        flowDelegate?.onPipelineClick(pipeline)
    }

    public func loadNextPage() {
        pageNumber += 1
        isLoadingNextPage = true

        Task { @MainActor [weak self] in
            guard let self else { return }

            screenState = .loading
            defer { isLoadingNextPage = false }

            do {
                let pipelines = try await dependencies.getPipelinesForProjectUseCase.invoke(
                    projectId: Int32(truncating: projectId),
                    pageNumber: Int32(pageNumber)
                )

                cachedPipelines.append(contentsOf: pipelines.items)
                hasNextPage = pipelines.pageInfo.hasNextPage
                screenState = .loaded(pipelines.items)
            } catch {
                screenState = .error
            }
        }
    }

    public func refresh() async {
        pageNumber = 1
        cachedPipelines = []

        do {
            let pipelines = try await dependencies.getPipelinesForProjectUseCase.invoke(
                projectId: Int32(truncating: projectId),
                pageNumber: Int32(pageNumber)
            )

            cachedPipelines = pipelines.items
            hasNextPage = pipelines.pageInfo.hasNextPage
            screenState = .loaded(pipelines.items)
        } catch {
            screenState = .error
        }
    }

    public func retry() {
        isRetryLoading = true

        loadData()
    }

    // MARK: - Private helpers

    private func loadData() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            screenState = .loading
            defer { isRetryLoading = false }

            do {
                let pipelines = try await dependencies.getPipelinesForProjectUseCase.invoke(
                    projectId: Int32(truncating: projectId),
                    pageNumber: Int32(pageNumber)
                )

                cachedPipelines = pipelines.items
                hasNextPage = pipelines.pageInfo.hasNextPage
                screenState = .loaded(pipelines.items)
            } catch {
                screenState = .error
            }
        }
    }
}
