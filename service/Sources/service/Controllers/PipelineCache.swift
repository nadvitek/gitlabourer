import Foundation
import Vapor

actor PipelineCache {
    private var storage: [String: PipelineStatus] = [:]

    func lastStatus(for key: String) -> PipelineStatus? {
        storage[key]
    }

    func updateStatus(_ status: PipelineStatus, for key: String) {
        storage[key] = status
    }

    func removeValue(for key: String) {
        storage.removeValue(forKey: key)
    }
}

struct PipelineCacheStorageKey: StorageKey {
    typealias Value = PipelineCache
}

extension Application {
    var pipelineCache: PipelineCache {
        get {
            if let cache = storage[PipelineCacheStorageKey.self] {
                return cache
            } else {
                let cache = PipelineCache()
                storage[PipelineCacheStorageKey.self] = cache
                return cache
            }
        }
        set {
            storage[PipelineCacheStorageKey.self] = newValue
        }
    }
}

