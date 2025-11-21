import Foundation

final class LoginViewModelMock: LoginViewModel {
    var isLoading: Bool
    var token: String
    var url: String
    var errorMessage: String
    var isOnboardingPresented: Bool = false

    init(
        isLoading: Bool = false,
        url: String = "",
        token: String = "",
        errorMessage: String = ""
    ) {
        self.isLoading = isLoading
        self.url = url
        self.token = token
        self.errorMessage = errorMessage
    }

    func login() {}
    func presentOnboarding() {}
}
