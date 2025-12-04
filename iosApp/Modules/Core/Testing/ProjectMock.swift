import Foundation
import shared

#if DEBUG

public extension Project {
    static var mock: Project {
        Project(
            id: 1944,
            name: "Gitlabourer Mobile App",
            description: "",
            webUrl: "https://gitlab.ack.ee/ebox/mobile-app",
            defaultBranch: "",
            visibility: "public",
            avatarUrl: nil,
            starCount: 3,
            forksCount: 0,
            createdAt: "2025-03-15T09:02:49.348Z",
            lastActivityAt: "2025-10-12T08:16:28.978Z",
            namespace: Namespace(id: 2062, name: "ebox", path: "ebox"),
            owner: nil
        )
    }
}

#endif
