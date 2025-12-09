import Foundation
import Vapor

struct FSString: Content {
    let stringValue: String
}

struct FSInteger: Content {
    let integerValue: String
}

struct SubscriptionFields: Content {
    let userId: FSString
    let baseUrl: FSString
    let token: FSString
    let apnsDeviceToken: FSString?
}

struct FirestoreDocument<F: Content>: Content {
    let name: String?
    let fields: F
    let createTime: String?
    let updateTime: String?
}

struct ListDocumentsResponse<F: Content>: Content {
    let documents: [FirestoreDocument<F>]?
}

