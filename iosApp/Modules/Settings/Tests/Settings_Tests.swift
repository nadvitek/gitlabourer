import Testing
import GitLabourer_Testing
@testable import Settings

struct Settings_Tests {

    @Test
    @MainActor
    func settingsView() async throws {
        AssertSnapshot.devices(SettingsView_Previews.testPreviews)
    }
}
