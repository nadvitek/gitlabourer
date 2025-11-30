import Foundation
import shared
import Observation
import UIKit

// MARK: - ProjectsViewModel

public protocol MergeRequestDetailViewModel {
    var screenState: MergeRequestDetailScreenState { get }
    var isRetryLoading: Bool { get }
    var isApprovalLoading: Bool { get }
    var isMergeLoading: Bool { get }

    func onAppear()
    func refresh() async
    func retry()
    func toggleApprove()
    func merge()
    func openUrl(urlString: String?)
    func onPipelineClick(pipeline: Pipeline)
}

// MARK: - ScreenState

public enum MergeRequestDetailScreenState {
    case loading
    case loaded(MergeRequestDetail)
    case error
}

// MARK: - ProjectsViewModelImpl

@Observable
public class MergeRequestDetailViewModelImpl: MergeRequestDetailViewModel {

    // MARK: - Internal properties

    public var screenState: MergeRequestDetailScreenState = .loading
    public var isRetryLoading: Bool = false
    public var isApprovalLoading: Bool = false
    public var isMergeLoading: Bool = false

    private let projectId: Int64
    private let mergeRequestId: Int64
    private var cachedDetail: MergeRequestDetail?
    private let dependencies: MergeRequestDetailViewModelDependencies
    private weak var flowDelegate: MergeRequestDetailFlowDelegate?

    // MARK: - Initializers

    public init(
        dependencies: MergeRequestDetailViewModelDependencies,
        flowDelegate: MergeRequestDetailFlowDelegate?,
        projectId: Int64,
        mergeRequestId: Int64
    ) {
        self.dependencies = dependencies
        self.flowDelegate = flowDelegate
        self.projectId = projectId
        self.mergeRequestId = mergeRequestId
    }

    // MARK: - Internal interface

    public func onAppear() {
        guard case .loading = screenState else { return }

        loadData()
    }

    public func refresh() async {
        do {
            let mergeRequestDetail = try await dependencies.getMergeRequestDetailUseCase.invoke(
                projectId: projectId,
                mergeRequestIid: mergeRequestId
            )

            cachedDetail = mergeRequestDetail
            screenState = .loaded(mergeRequestDetail)
        } catch {
            screenState = .error
        }
    }

    public func retry() {
        isRetryLoading = true

        loadData()
    }

    public func openUrl(urlString: String?) {
        guard
            let urlString,
            let url = URL(string: urlString),
            UIApplication.shared.canOpenURL(url)
        else { return }

        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:])
        }
    }

    public func toggleApprove() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            isApprovalLoading = true
            defer { isApprovalLoading = false }

            do {
                let approvalState: MergeRequestApprovalState = (cachedDetail?.approved ?? false) ? .unapproved : .approved

                let mergeRequestDetail = try await dependencies.changeMergeRequestApprovalUseCase.invoke(
                    projectId: projectId,
                    mergeRequestIid: mergeRequestId,
                    state: approvalState
                )

                cachedDetail = mergeRequestDetail
                screenState = .loaded(mergeRequestDetail)
            } catch {
                screenState = .error
            }
        }
    }

    public func merge() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            isMergeLoading = true
            defer { isMergeLoading = false }

            do {
                let mergeRequestDetail = try await dependencies.mergeMergeRequestUseCase.invoke(
                    projectId: projectId,
                    mergeRequestIid: mergeRequestId
                )

                cachedDetail = mergeRequestDetail
                screenState = .loaded(mergeRequestDetail)
            } catch {
                screenState = .error
            }
        }
    }

    public func onPipelineClick(pipeline: Pipeline) {
        flowDelegate?.onPipelineClick(pipeline)
    }

    // MARK: - Private helpers

    private func loadData() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            defer { isRetryLoading = false }

            do {
                let mergeRequestDetail = try await dependencies.getMergeRequestDetailUseCase.invoke(
                    projectId: projectId,
                    mergeRequestIid: mergeRequestId
                )

                cachedDetail = mergeRequestDetail
                screenState = .loaded(mergeRequestDetail)
            } catch {
                screenState = .error
            }
        }
    }
}

