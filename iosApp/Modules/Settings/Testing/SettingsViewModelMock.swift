import Foundation
import shared

final class SettingsViewModelMock: SettingsViewModel {
    var isNotificationOn: Bool = true
    var isNotificationLoading: Bool = false
    var user: User?

    init(
        user: User = .init(
            id: 1,
            username: "vit.nademlejnsky",
            name: "Vít Nademlejnský",
            state: "",
            avatarUrl: "",
            webUrl: "",
            email: "vit.nademlejnsky@ackee.cz"
        )
    ) {
        self.user = user
    }

    func logout() {}
    func onAppear() {}
}
