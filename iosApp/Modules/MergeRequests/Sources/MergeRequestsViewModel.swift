import Foundation
import shared
import Observation

// MARK: - ProjectsViewModel

public protocol MergeRequestsViewModel {
    var screenState: [MergeRequestState: MergeRequestsScreenState] { get }
    var selectedState: MergeRequestState { get set }

    func isStateSelected(_ state: MergeRequestState) -> Bool
    func onAppear()
    func selectState(state: MergeRequestState)
}

// MARK: - ScreenState

public enum MergeRequestsScreenState {
    case loading
    case loaded([MergeRequest])
}

// MARK: - ProjectsViewModelImpl

@Observable
public class MergeRequestsViewModelImpl: MergeRequestsViewModel {

    // MARK: - Internal properties

    public var screenState: [MergeRequestState: MergeRequestsScreenState] = [:]
    public var selectedState: MergeRequestState = .opened

    private let projectId: KotlinInt?
    private let dependencies: MergeRequestsViewModelDependencies
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
        loadData()
    }

    public func selectState(state: MergeRequestState) {
        selectedState = state
        loadData()
    }

    public func isStateSelected(_ state: MergeRequestState) -> Bool {
        selectedState == state
    }

    // MARK: - Private helpers

    private func loadData() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                let mergeRequests = try await dependencies.getMergeRequestsUseCase.invoke(
                    state: selectedState,
                    projectId: projectId
                )

                screenState[selectedState] = .loaded(mergeRequests)
            } catch {
                
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
        default: "Not possible"
        }
    }
}
