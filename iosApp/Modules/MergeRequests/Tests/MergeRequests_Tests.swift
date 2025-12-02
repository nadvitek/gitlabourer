import Testing
import GitLabourer_Testing
@testable import MergeRequests

struct MergeRequests_Tests {

    @Test
    @MainActor
    func mergeRequestsView() async throws {
        AssertSnapshot.devices(MergeRequestsView_Previews.testPreviews)
    }
}
