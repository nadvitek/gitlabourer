import Foundation
import Vapor

struct UnsubscribeRequest: Content {
    let userId: String
    let baseUrl: String
}
