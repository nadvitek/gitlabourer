import SwiftUI

public extension PreviewProvider {
    static var testPreviews: some View {
        previews
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gitlabourerBackground()
            .preferredColorScheme(.dark)
    }
}
