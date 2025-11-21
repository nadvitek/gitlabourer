import Foundation
import shared
import Observation

// MARK: - SettingsViewModel

public protocol SettingsViewModel {
    var user: User? { get }

    func logout()
    func onAppear()
}

// MARK: - SettingsViewModelImpl

@Observable
public class SettingsViewModelImpl: SettingsViewModel {

    // MARK: - Public properties

    public var user: User?

    // MARK: - Private properties

    private weak var flowDelegate: SettingsFlowDelegate?
    private let dependencies: SettingsViewModelDependencies

    // MARK: - Initializers

    public init(
        flowDelegate: SettingsFlowDelegate?,
        dependencies: SettingsViewModelDependencies,
        user: User?
    ) {
        self.flowDelegate = flowDelegate
        self.dependencies = dependencies
        self.user = user
    }

    // MARK: - Internal interface

    public func onAppear() {
        Task {
            do {
                let user = try await dependencies.getUserUseCase.invoke()

                self.user = user
            } catch {
            }
        }
    }

    public func logout() {
        Task {
            try? await dependencies.logoutUseCase.invoke()
            UserDefaults.standard.isLoggedIn = false
            flowDelegate?.logout()
        }
    }
}
