import Foundation
import shared

class ProjectsViewModelMock: ProjectsViewModel {
    
    // MARK: - Properties
    
    var screenState: ProjectsScreenState
    var isLoading: Bool = false
    var isLoadingNextPage: Bool = false
    var hasNextPage: Bool = false

    // MARK: - Initializers
    
    init(screenState: ProjectsScreenState = .loading) {
        self.screenState = screenState
    }
    
    // MARK: - Internal interface
    
    func onAppear() {}
    func retry() {}
    func logout() {}
    func loadNextPage() {}
    func refresh() {}
    func onProjectClick(_ project: Project) {}
}
