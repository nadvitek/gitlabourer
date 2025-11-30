import Foundation
import shared
import Observation
import shared

// MARK: - ProjectsViewModel

public protocol SearchViewModel {
    var screenState: SearchScreenState { get }
    var isLoading: Bool { get }
    var isPresented: Bool { get set }
    var text: String { get set }

    func retry()
    func onProjectClick(_ project: Project)
}

// MARK: - ScreenState

public enum SearchScreenState: Equatable {
    case loading
    case loaded([Project])
    case error
}

// MARK: - ProjectsViewModelImpl

@Observable
public class SearchViewModelImpl: SearchViewModel {

    // MARK: - Internal properties

    public var screenState: SearchScreenState = .loaded([])
    public var isLoading: Bool = false
    public var text: String = "" {
        didSet {
            searchData()
        }
    }
    public var isPresented: Bool = true

    private var lastSearchedText: String = ""
    private var searchTask: Task<Void, Never>?
    private let dependencies: SearchViewModelDependencies
    private weak var flowDelegate: SearchFlowDelegate?
    private var projects: [Project] = []

    // MARK: - Initializers

    public init(
        dependencies: SearchViewModelDependencies,
        flowDelegate: SearchFlowDelegate?
    ) {
        self.dependencies = dependencies
        self.flowDelegate = flowDelegate
    }

    // MARK: - Internal helpers

    public func retry() {
        screenState = .loading
        searchData()
    }

    public func onProjectClick(_ project: Project) {
        flowDelegate?.onProjectClick(project)
    }

    // MARK: - Private helpers

    private func searchData() {
        guard !text.isEmpty else { screenState = .loaded([]); return }
        guard lastSearchedText != text else { return }

        screenState = .loading

        searchTask?.cancel()
        searchTask = Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 1_000_000_000)

            guard
                let self,
                !Task.isCancelled
            else { return }

            defer { isLoading = false }

            do {
                let projects = try await dependencies.searchProjectsUseCase.invoke(
                    text: text
                )

                lastSearchedText = text
                screenState = .loaded(projects)
            } catch {
                screenState = .error
            }
        }
    }
}
