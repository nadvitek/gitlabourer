import Foundation

class ProjectsViewModelMock: ProjectsViewModel {
    
    // MARK: - Properties
    
    var screenState: ProjectsScreenState
    var isLoading: Bool = false
    
    // MARK: - Initializers
    
    init(screenState: ProjectsScreenState = .loading) {
        self.screenState = screenState
    }
    
    // MARK: - Internal interface
    
    func onAppear() {}
    func retry() {}
    func logout() {}
}
