import Foundation
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private lazy var appFlowCoordinator = AppFlowCoordinator()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        appFlowCoordinator.start(in: window)
        window.makeKeyAndVisible()
        self.window = window
    }

    @available(iOS 26.0, *)
    func preferredWindowingControlStyle(
        for scene: UIWindowScene
    ) -> UIWindowScene.WindowingControlStyle {
        .minimal
    }
}
