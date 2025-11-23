import Foundation
import UIKit
import SwiftUI

public struct AttributedText: UIViewRepresentable {
    let attributedString: NSAttributedString

    public init(attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }

    public func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.isSelectable = true
        tv.dataDetectorTypes = .link
        tv.backgroundColor = .clear
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        tv.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        tv.textContainer.lineBreakMode = .byWordWrapping

        tv.linkTextAttributes = [
            .foregroundColor: GitlabColors.gitlabOrange.color
        ]
        return tv
    }

    public func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedString
    }

    public func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize {
        let targetWidth = proposal.width ?? UIScreen.main.bounds.width
        let size = uiView.sizeThatFits(CGSize(width: targetWidth, height: .greatestFiniteMagnitude))
        return CGSize(width: targetWidth, height: size.height)
    }
}
