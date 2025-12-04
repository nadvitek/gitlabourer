import Testing
import GitLabourer_Testing
@testable import Projects

struct Projects_Tests {

    @Test
    @MainActor
    func projectsView() async throws {
        AssertSnapshot.devices(ProjectsView_Previews.testPreviews)
    }
}
