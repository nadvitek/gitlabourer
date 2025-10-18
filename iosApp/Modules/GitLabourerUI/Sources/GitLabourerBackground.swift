import SwiftUI

internal struct GitlabourerBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: [
                        GitlabColors.gitlabDark.swiftUIColor.opacity(0.6),
                        GitlabColors.gitlabAccent.swiftUIColor.opacity(0.75)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

extension View {
    public func gitlabourerBackground() -> some View {
        self.modifier(GitlabourerBackgroundModifier())
    }
}
