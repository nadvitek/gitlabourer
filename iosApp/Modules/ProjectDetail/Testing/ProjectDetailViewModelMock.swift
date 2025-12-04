import Foundation
import shared
import Core

final class ProjectDetailViewModelMock: ProjectDetailViewModel {
    var project: Project

    init(
        project: Project = .mock
    ) {
        self.project = project
    }

    func handleProjectDetailPath(_ path: ProjectDetailPath) {}
}
