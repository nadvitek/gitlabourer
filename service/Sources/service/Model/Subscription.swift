import Foundation
import Vapor

struct Subscription: Content {
    let userId: String
    let baseUrl: String
    let token: String
}
