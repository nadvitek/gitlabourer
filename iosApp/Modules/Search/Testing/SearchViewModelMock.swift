

final class SearchViewModelMock: SearchViewModel {
    var screenState: SearchScreenState
    var isLoading: Bool = false
    var isPresented: Bool = true
    var text: String = ""

    init(screenState: SearchScreenState = SearchScreenState.loading) {
        self.screenState = screenState
    }

    func retry() {}
}
