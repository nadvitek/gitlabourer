import SwiftUI

public enum Orientation: String {
    case portrait, landscape
}

private extension Orientation {
    init(size: CGSize) {
        self = size.width > size.height ? .landscape : .portrait
    }
}

struct OrientationModifier: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            let orientation = Orientation(size: proxy.size)

            content
        }
        .ignoresSafeArea(.keyboard)
    }
}

public extension View {
    /// Observe view orientation using `deviceInfo` environment value.
    ///
    /// This modifier wraps view to `GeometryReader` therefore it should be used on views
    /// that cover the whole screen or majority of it.
    ///
    /// Ideal usage is to use it on `WindowGroup` in your `App` scene
    func observingOrientation() -> some View {
        modifier(OrientationModifier())
    }
}
