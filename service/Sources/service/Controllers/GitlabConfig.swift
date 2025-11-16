import Foundation
import Vapor

struct GitLabConfig {
    let baseURL: URI
    let token: String
}

struct GitLabConfigKey: StorageKey {
    typealias Value = GitLabConfig
}

extension Application {
    var gitlabConfig: GitLabConfig {
        get { storage[GitLabConfigKey.self]! }
        set { storage[GitLabConfigKey.self] = newValue }
    }
}

