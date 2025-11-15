import Foundation
import shared

final class SettingsViewModelMock: SettingsViewModel {
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
