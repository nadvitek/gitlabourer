import Testing
import GitLabourer_Testing
@testable import MergeRequestDetail

struct MergeRequestDetail_Tests {

    @Test
    @MainActor
    func mrDetailView() async throws {
        AssertSnapshot.devices(MergeRequestDetailView_Previews.testPreviews, scrollViewMultiplier: 1.7)
    }
}
