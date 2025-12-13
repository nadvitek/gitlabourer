import Foundation
import shared
import Observation

// MARK: - SettingsViewModel

public protocol SettingsViewModel {
    var user: User? { get }
    var isNotificationOn: Bool { get set }
    var isNotificationLoading: Bool { get }

    func logout()
    func onAppear()
}

// MARK: - SettingsViewModelImpl

@Observable
public class SettingsViewModelImpl: SettingsViewModel {

    // MARK: - Public properties

    public var user: User?
    public var isNotificationOn: Bool {
        get {
            notificationToggleHelper
        }
        set {
            updateNotificationSettings(to: newValue)
        }
    }
    public var isNotificationLoading: Bool = false

    // MARK: - Private properties

    private weak var flowDelegate: SettingsFlowDelegate?
    private var notificationToggleHelper: Bool = false
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

    // MARK: - Public interface

    public func onAppear() {
        Task {
            do {
                let user = try await dependencies.getUserUseCase.invoke()
                let notificationSettings = try await dependencies.getNotificationsSettingsUseCase.invoke()

                self.user = user
                self.notificationToggleHelper = notificationSettings.boolValue
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

    // MARK: - Private helpers

    private func updateNotificationSettings(to value: Bool) {
        Task { [weak self] in
            guard let self else { return }
            defer { isNotificationLoading = false }
            isNotificationLoading = true
            do {
                let success = if value {
                    try await dependencies.subscribeForNotificationUseCase.invoke()
                } else {
                    try await dependencies.unsubscribeForNotificationUseCase.invoke()
                }

                if success.boolValue {
                    notificationToggleHelper = value
                }
            } catch {
                print(error)
            }
        }
    }
}
