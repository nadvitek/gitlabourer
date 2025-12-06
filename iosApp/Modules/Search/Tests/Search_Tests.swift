import Testing
import GitLabourer_Testing
@testable import Search

struct Search_Tests {

    @Test
    @MainActor
    func searchViewEmpty() async throws {
        AssertSnapshot.devices(SearchViewEmpty_Previews.testPreviews)
    }

    @Test
    @MainActor
    func searchView() async throws {
        AssertSnapshot.devices(SearchView_Previews.testPreviews)
    }
}
