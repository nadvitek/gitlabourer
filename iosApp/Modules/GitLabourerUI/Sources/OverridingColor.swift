import Foundation
import UIKit

public func overridingColor(_ attributed: NSAttributedString, color: UIColor) -> NSAttributedString {
    let mutable = NSMutableAttributedString(attributedString: attributed)
    let fullRange = NSRange(location: 0, length: mutable.length)
    mutable.removeAttribute(.foregroundColor, range: fullRange)
    mutable.addAttribute(.foregroundColor, value: color, range: fullRange)
    return mutable
}
