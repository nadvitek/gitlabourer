import Foundation
import shared

public struct SettingsViewModelDependencies {
    let getUserUseCase: GetUserUseCase
    let logoutUseCase: LogoutUseCase
    let subscribeForNotificationUseCase: SubscribeForNotificationUseCase
    let unsubscribeForNotificationUseCase: UnsubscribeForNotificationUseCase
    let getNotificationsSettingsUseCase: GetNotificationsSettingsUseCase

    public init(
        getUserUseCase: GetUserUseCase,
        logoutUseCase: LogoutUseCase,
        subscribeForNotificationUseCase: SubscribeForNotificationUseCase,
        unsubscribeForNotificationUseCase: UnsubscribeForNotificationUseCase,
        getNotificationsSettingsUseCase: GetNotificationsSettingsUseCase
    ) {
        self.getUserUseCase = getUserUseCase
        self.logoutUseCase = logoutUseCase
        self.subscribeForNotificationUseCase = subscribeForNotificationUseCase
        self.unsubscribeForNotificationUseCase = unsubscribeForNotificationUseCase
        self.getNotificationsSettingsUseCase = getNotificationsSettingsUseCase
    }
}
