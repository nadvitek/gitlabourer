import Testing
import GitLabourer_Testing
@testable import Jobs

struct Jobs_Tests {

    @Test
    @MainActor
    func jobsList() async throws {
        AssertSnapshot.devices(JobsListView_Previews.testPreviews)
    }

    @Test
    @MainActor
    func jobsPipeline() async throws {
        AssertSnapshot.devices(JobPipelineView_Previews.testPreviews, scrollViewMultiplier: 1.7)
    }

    @Test
    @MainActor
    func jobsDetailView() async throws {
        AssertSnapshot.device(JobsDetailView_Previews.testPreviews, device: landscapeDevice)
    }
}
