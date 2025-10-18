import Foundation
import shared
import Observation

// MARK: - ProjectsViewModel

public protocol ProjectsViewModel {
    var screenState: ProjectsScreenState { get }
    var isLoading: Bool { get }
    
    func onAppear()
    func retry()
    func logout()
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

    private var pageNumber: Int = 0
    private let dependencies: ProjectsViewModelDependencies
    private var projects: [Project] = []
    
    // MARK: - Initializers
    
    public init(dependencies: ProjectsViewModelDependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Internal interface
    
    public func onAppear() {
        loadData()
    }
    
    public func retry() {
        isLoading = true
        
        loadData()
    }
    
    public func logout() {
        UserDefaults.standard.set(false, forKey: "loggedIn")
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
                
                screenState = .loaded(projects)
                
                print("Screen state is \(screenState)")
            } catch {
                screenState = .error
            }
        }
    }
}
