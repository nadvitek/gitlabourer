import Testing
import GitLabourer_Testing
@testable import Login

struct Login_Tests {

    @Test
    @MainActor
    func loginView() async throws {
        AssertSnapshot.devices(LoginView_Previews.testPreviews)
    }

    @Test
    @MainActor
    func onboardingView() async throws {
        AssertSnapshot.devices(OnboardingView_Previews.testPreviews)
    }
}
