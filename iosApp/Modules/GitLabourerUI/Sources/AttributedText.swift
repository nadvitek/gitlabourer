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
        tv.isScrollEnabled = true
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
}
