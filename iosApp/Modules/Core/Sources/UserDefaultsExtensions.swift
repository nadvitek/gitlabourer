import Foundation

public extension UserDefaults {
    private static var isUserLoggedIn = "IS_LOGGED_IN"

    var isLoggedIn: Bool {
        get { bool(forKey: Self.isUserLoggedIn) }
        set { set(newValue, forKey: Self.isUserLoggedIn) }
    }
}
