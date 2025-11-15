import Foundation
import shared

public protocol LoginFlowDelegate: AnyObject {
    func logIn(user: User)
}
