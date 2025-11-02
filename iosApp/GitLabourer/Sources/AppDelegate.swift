import Foundation
import UIKit
import shared

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        let orientations: UIInterfaceOrientationMask = UIDevice.current.userInterfaceIdiom == .pad ? .all : [.portrait, .landscape]
        return orientations
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        KoinKt.doInitKoin(extraModules: [])
        return true
    }
}
