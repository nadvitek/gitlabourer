import Testing
import GitLabourer_Testing
@testable import Repository

struct Repository_Tests {

    @Test
    @MainActor
    func repositoryView() async throws {
        AssertSnapshot.devices(RepositoryView_Previews.testPreviews)
    }
}
