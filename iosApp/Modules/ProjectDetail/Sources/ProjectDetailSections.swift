import Foundation
import SwiftUI

public enum ProjectDetailSection: CaseIterable, Equatable {
    // TODO: - Implement later
//    case manage
    case code
    case build

    var title: String {
        switch self {
//        case .manage:
//            "Manage"
        case .code:
            "Code"
        case .build:
            "Build"
        }
    }

    var paths: [ProjectDetailPath] {
        switch self {
//        case .manage:
//            [
//                .members
//            ]
        case .code:
            [
                .repository,
                .mrs,
//                .tags
            ]
        case .build:
            [
                .pipelines,
                .jobs
            ]
        }
    }
}

public enum ProjectDetailPath: CaseIterable, Equatable {
    case repository
    case members
    case mrs
    case pipelines
    case jobs
    case tags

    var text: String {
        switch self {
        case .repository:
            "Repository"
        case .members:
            "Members"
        case .mrs:
            "Merge requests"
        case .pipelines:
            "Pipelines"
        case .jobs:
            "Jobs"
        case .tags:
            "Tags"
        }
    }

    var image: Image {
        switch self {
        case .repository:
            Image(systemName: "folder.fill")
        case .members:
            Image(systemName: "person.2.fill")
        case .mrs:
            Image(systemName: "point.topleft.filled.down.to.point.bottomright.curvepath")
        case .pipelines:
            Image(systemName: "checklist")
        case .jobs:
            Image(systemName: "hammer.fill")
        case .tags:
            Image(systemName: "tag.fill")
        }
    }
}
