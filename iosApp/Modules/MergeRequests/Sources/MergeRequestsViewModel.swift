import Foundation
import shared
import Observation

// MARK: - ProjectsViewModel

public protocol MergeRequestsViewModel {
    var screenState: [MergeRequestState: MergeRequestsScreenState] { get }
    var selectedState: MergeRequestState { get set }
    var hasNextPage: [MergeRequestState: Bool] { get }
    var isLoadingNextPage: [MergeRequestState: Bool] { get }
    var isRetryLoading: [MergeRequestState: Bool] { get }

    func isStateSelected(_ state: MergeRequestState) -> Bool
    func hasCurrentStateNextPage() -> Bool
    func onAppear()
    func refresh() async
    func retry()
    func loadNextPage()
    func selectState(state: MergeRequestState)
}

// MARK: - ScreenState

public enum MergeRequestsScreenState {
    case loading
    case loaded([MergeRequest])
    case error
}

// MARK: - ProjectsViewModelImpl

@Observable
public class MergeRequestsViewModelImpl: MergeRequestsViewModel {

    // MARK: - Internal properties

    public var screenState: [MergeRequestState: MergeRequestsScreenState] = [:]
    public var selectedState: MergeRequestState = .opened
    public var hasNextPage: [MergeRequestState: Bool] = [:]
    public var isLoadingNextPage: [MergeRequestState: Bool] = [:]
    public var isRetryLoading: [MergeRequestState: Bool] = [:]

    private let projectId: KotlinInt?
    private let dependencies: MergeRequestsViewModelDependencies
    private var cachedMergeRequests: [MergeRequestState: [MergeRequest]] = [:]
    private var pageNumber = 0
    private weak var flowDelegate: MergeRequestsFlowDelegate?

    // MARK: - Initializers

    public init(
        dependencies: MergeRequestsViewModelDependencies,
        flowDelegate: MergeRequestsFlowDelegate?,
        projectId: KotlinInt?
    ) {
        self.dependencies = dependencies
        self.flowDelegate = flowDelegate
        self.projectId = projectId

        MergeRequestState.allCases.forEach {
            screenState[$0] = .loading
        }
    }

    // MARK: - Internal interface

    public func onAppear() {
        guard case .loading = screenState[selectedState] else { return }

        loadData()
    }

    public func selectState(state: MergeRequestState) {
        selectedState = state
        loadData()
    }

    public func isStateSelected(_ state: MergeRequestState) -> Bool {
        selectedState == state
    }

    public func refresh() async {
        pageNumber = 0
        cachedMergeRequests[selectedState] = []
        let currentState = selectedState

        do {
            let mergeRequests = try await dependencies.getMergeRequestsUseCase.invoke(
                state: selectedState,
                projectId: projectId,
                pageNumber: 0
            )

            cachedMergeRequests[currentState] = mergeRequests.items
            hasNextPage[currentState] = mergeRequests.pageInfo.hasNextPage
            screenState[currentState] = .loaded(mergeRequests.items)
        } catch {
            screenState[currentState] = .error
        }
    }

    public func loadNextPage() {
        pageNumber += 1
        isLoadingNextPage[selectedState] = true

        Task { @MainActor [weak self] in
            guard let self else { return }

            let currentState = selectedState
            defer { isLoadingNextPage[currentState] = false }

            do {
                let mergeRequests = try await dependencies.getMergeRequestsUseCase.invoke(
                    state: selectedState,
                    projectId: projectId,
                    pageNumber: Int32(pageNumber)
                )

                cachedMergeRequests[currentState]?.append(contentsOf: mergeRequests.items)
                hasNextPage[currentState] = mergeRequests.pageInfo.hasNextPage
                if let mrs = cachedMergeRequests[currentState] {
                    screenState[currentState] = .loaded(mrs)
                }
            } catch {
                screenState[currentState] = .error
            }
        }
    }

    public func retry() {
        isRetryLoading[selectedState] = true

        loadData()
    }

    public func hasCurrentStateNextPage() -> Bool {
        hasNextPage[selectedState] ?? false
    }

    // MARK: - Private helpers

    private func loadData() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            let currentState = selectedState
            defer { isRetryLoading[currentState] = false }

            do {
                let mergeRequests = try await dependencies.getMergeRequestsUseCase.invoke(
                    state: selectedState,
                    projectId: projectId,
                    pageNumber: 0
                )

                cachedMergeRequests[currentState] = mergeRequests.items
                hasNextPage[currentState] = mergeRequests.pageInfo.hasNextPage
                screenState[currentState] = .loaded(mergeRequests.items)
            } catch {
                screenState[currentState] = .error
            }
        }
    }
}

extension MergeRequestState {
    public static var allCases: [MergeRequestState] {
        [.opened, .merged, .closed, .all]
    }

    public var title: String {
        switch self {
        case .opened: "Opened"
        case .merged: "Merged"
        case .closed: "Closed"
        case .all: "All"
        }
    }
}
