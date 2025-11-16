import Foundation
import Vapor

struct SubscribeRequest: Content {
    let userId: String
    let baseUrl: String
    let token: String
}
