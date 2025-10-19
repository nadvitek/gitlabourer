import SwiftUI

public extension View {
    /// Creates `UIHostingController` that is observing orientation using `GeometryReader`,
    /// because of this it should be used only for views that cover the whole screen or majority of it.
    ///
    /// Orientation is propagated to `orientation` in `EnvironmentValues`.
    func hosting(
        isTabBarHidden: Bool = true,
        isBackButtonHidden: Bool = false,
        supportedOrientations: UIInterfaceOrientationMask = .portrait,
    ) -> HostingController<some View> {
        .init(
            isTabBarHidden: isTabBarHidden,
            isBackButtonHidden: isBackButtonHidden,
            supportedOrientations: supportedOrientations,
            rootView: observingOrientation()
        )
    }
}

// swiftlint:disable:next hosting_controller
public final class HostingController<Content: View>: UIHostingController<Content> {
    private var _supportedOrientations: UIInterfaceOrientationMask
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        _supportedOrientations
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    private let isTabBarHidden: Bool
    private let isBackButtonHidden: Bool

    public init(
        isTabBarHidden: Bool,
        isBackButtonHidden: Bool,
        supportedOrientations: UIInterfaceOrientationMask = .portrait,
        rootView: Content
    ) {
        self.isTabBarHidden = isTabBarHidden
        self.isBackButtonHidden = isBackButtonHidden
        self._supportedOrientations = supportedOrientations
        super.init(rootView: rootView)
    }

    @MainActor
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        super.loadView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.topViewController?.navigationItem.hidesBackButton = isBackButtonHidden
        navigationController?.tabBarController?.isTabBarHidden = isTabBarHidden
    }
}

