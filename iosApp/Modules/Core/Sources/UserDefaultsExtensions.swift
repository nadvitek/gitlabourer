import Foundation

public extension UserDefaults {
    private static var isUserLoggedIn = "IS_LOGGED_IN"
    private static var wasOnboarded = "WAS_ONBOARDED"

    var isLoggedIn: Bool {
        get { bool(forKey: Self.isUserLoggedIn) }
        set { set(newValue, forKey: Self.isUserLoggedIn) }
    }

    var wasOnboarded: Bool {
        get { bool(forKey: Self.wasOnboarded) }
        set { set(newValue, forKey: Self.wasOnboarded) }
    }
}
