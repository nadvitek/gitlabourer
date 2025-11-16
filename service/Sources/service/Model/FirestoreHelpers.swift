import Foundation
import Vapor

// Generic Firestore value wrappers we need
struct FSString: Content {
    let stringValue: String
}

struct FSInteger: Content {
    let integerValue: String
}

// Fields for our Subscription document
struct SubscriptionFields: Content {
    let userId: FSString
    let baseUrl: FSString
    let token: FSString
}

// Full Firestore document wrapper
struct FirestoreDocument<F: Content>: Content {
    let name: String?
    let fields: F
    let createTime: String?
    let updateTime: String?
}

// Wrapper for listDocuments response
struct ListDocumentsResponse<F: Content>: Content {
    let documents: [FirestoreDocument<F>]?
}

