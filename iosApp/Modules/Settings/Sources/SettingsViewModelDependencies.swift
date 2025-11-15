import Foundation
import shared

public struct SettingsViewModelDependencies {
    let getUserUseCase: GetUserUseCase
    let logoutUseCase: LogoutUseCase

    public init(
        getUserUseCase: GetUserUseCase,
        logoutUseCase: LogoutUseCase
    ) {
        self.getUserUseCase = getUserUseCase
        self.logoutUseCase = logoutUseCase
    }
}
