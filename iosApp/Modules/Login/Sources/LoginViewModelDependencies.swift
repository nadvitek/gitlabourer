import Foundation
import shared

public struct LoginViewModelDependencies {
    public let loginUseCase: LoginUseCase

    public init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
}

