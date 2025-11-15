import Foundation

final class LoginViewModelMock: LoginViewModel {
    var isLoading: Bool
    var token: String
    var url: String
    var errorMessage: String

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
}
