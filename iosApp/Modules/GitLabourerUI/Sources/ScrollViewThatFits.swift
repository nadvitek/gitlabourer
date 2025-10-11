import SwiftUI

public struct ScrollViewThatFits<Content: View>: View {
    let axis: Axis.Set
    let showsIndicators: Bool
    @ViewBuilder let content: Content

    // MARK: - Initialization

    public init(
        _ axis: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.axis = axis
        self.showsIndicators = showsIndicators
    }

    // MARK: - Body

    public var body: some View {
        ScrollView(axis, showsIndicators: showsIndicators) {
            content
        }
        .scrollBounceBehavior(.basedOnSize, axes: axis)
    }
}
