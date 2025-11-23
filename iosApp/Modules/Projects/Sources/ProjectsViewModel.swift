import Foundation
import shared
import Observation

// MARK: - ProjectsViewModel

public protocol ProjectsViewModel {
    var screenState: ProjectsScreenState { get }
    var isLoading: Bool { get }
    var isLoadingNextPage: Bool { get }
    var hasNextPage: Bool { get }

    func onAppear()
    func refresh() async
    func retry()
    func logout()
    func loadNextPage()
    func onProjectClick(_ project: Project)
}

// MARK: - ScreenState

public enum ProjectsScreenState {
    case loading
    case loaded([Project])
    case error
}

// MARK: - ProjectsViewModelImpl

@Observable
public class ProjectsViewModelImpl: ProjectsViewModel {
    
    // MARK: - Internal properties
    
    public var screenState: ProjectsScreenState = .loading
    public var isLoading: Bool = false
    public var isLoadingNextPage: Bool = false
    public var hasNextPage: Bool = false

    private var pageNumber: Int = 0
    private let dependencies: ProjectsViewModelDependencies
    private weak var flowDelegate: ProjectsFlowDelegate?
    private var cachedProjects: [Project] = []

    // MARK: - Initializers
    
    public init(
        dependencies: ProjectsViewModelDependencies,
        flowDelegate: ProjectsFlowDelegate?
    ) {
        self.dependencies = dependencies
        self.flowDelegate = flowDelegate
    }
    
    // MARK: - Internal interface
    
    public func onAppear() {
        guard case .loading = screenState else { return }

        loadData()
    }
    
    public func retry() {
        isLoading = true
        
        loadData()
    }
    
    public func logout() {
        UserDefaults.standard.set(false, forKey: "loggedIn")
    }

    public func onProjectClick(_ project: Project) {
        flowDelegate?.onProjectClick(project)
    }

    public func refresh() async {
        pageNumber = 0
        cachedProjects = []

        do {
            let projects = try await dependencies.getProjectsUseCase.invoke(
                pageNumber: Int32(pageNumber)
            )

            hasNextPage = projects.pageInfo.hasNextPage
            cachedProjects = projects.items
            screenState = .loaded(projects.items)
        } catch {
            screenState = .error
        }
    }

    public func loadNextPage() {
        pageNumber += 1
        isLoadingNextPage = true

        Task { @MainActor [weak self] in
            guard let self else { return }

            defer { isLoadingNextPage = false }

            do {
                let projects = try await dependencies.getProjectsUseCase.invoke(
                    pageNumber: Int32(pageNumber)
                )

                hasNextPage = projects.pageInfo.hasNextPage
                cachedProjects += projects.items
                screenState = .loaded(cachedProjects)
            } catch {
                screenState = .error
            }
        }
    }

    // MARK: - Private helpers
    
    private func loadData() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            defer { isLoading = false }
            
            do {
                let projects = try await dependencies.getProjectsUseCase.invoke(
                    pageNumber: Int32(pageNumber)
                )

                hasNextPage = projects.pageInfo.hasNextPage
                cachedProjects = projects.items
                screenState = .loaded(projects.items)
            } catch {
                screenState = .error
            }
        }
    }
}
