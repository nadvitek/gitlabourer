import Foundation

final class LoginViewModelMock: LoginViewModel {
    var isLoading: Bool
    var token: String
    var errorMessage: String

    init(
        isLoading: Bool = false,
        token: String = "",
        errorMessage: String = ""
    ) {
        self.isLoading = isLoading
        self.token = token
        self.errorMessage = errorMessage
    }

    func login() {}
}
