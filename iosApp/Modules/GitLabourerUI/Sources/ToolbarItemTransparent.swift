import SwiftUI

public struct ToolbarItemTransparent<Content: View>: ToolbarContent {
    
    let placement: ToolbarItemPlacement
    let content: Content
    
    public init(
        placement: ToolbarItemPlacement,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.placement = placement
        self.content = content()
    }
    
    public var body: some ToolbarContent {
        if #available(iOS 26.0, *) {
            ToolbarItem(placement: placement) {
                content
                    .padding(.leading, -5)
            }
            .sharedBackgroundVisibility(.hidden)
        } else {
            ToolbarItem(placement: placement) {
                content
            }
        }
    }
}
