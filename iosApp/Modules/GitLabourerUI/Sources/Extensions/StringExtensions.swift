import Foundation
import UIKit

public extension String {
    func uiImageFromBase64() -> UIImage? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return UIImage(data: data)
    }
}
