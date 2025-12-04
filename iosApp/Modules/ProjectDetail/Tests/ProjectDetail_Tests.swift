import Testing
import GitLabourer_Testing
@testable import ProjectDetail

struct ProjectDetail_Tests {

    @Test
    @MainActor
    func projectDetailView() async throws {
        AssertSnapshot.devices(ProjectDetailView_Previews.testPreviews)
    }
}
