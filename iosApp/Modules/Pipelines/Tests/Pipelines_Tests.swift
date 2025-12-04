import Testing
import GitLabourer_Testing
@testable import Pipelines

struct Pipelines_Tests {

    @Test
    @MainActor
    func pipelinesView() async throws {
        AssertSnapshot.devices(PipelinesView_Previews.testPreviews)
    }
}
