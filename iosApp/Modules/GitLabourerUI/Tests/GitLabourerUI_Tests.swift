import Testing
import GitLabourer_Testing
@testable import GitLabourerUI

struct GitlabourerTests {

    @Test
    @MainActor
    func primaryButton() async throws {
        AssertSnapshot.devices(PrimaryButton_Previews.testPreviews)
    }

    @Test
    @MainActor
    func secondaryButton() async throws {
        AssertSnapshot.devices(SecondaryButton_Previews.testPreviews)
    }

    @Test
    @MainActor
    func textField() async throws {
        AssertSnapshot.devices(GitLabourerTextField_Previews.testPreviews)
    }

    @Test
    @MainActor
    func errorState() async throws {
        AssertSnapshot.devices(ErrorStateView_Previews.testPreviews)
    }

    @Test
    @MainActor
    func jobState() async throws {
        AssertSnapshot.devices(JobStateView_Previews.testPreviews)
    }

    @Test
    @MainActor
    func projectItem() async throws {
        AssertSnapshot.devices(ProjectItemView_Previews.testPreviews)
    }
}
