import Foundation
import shared
import Observation

// MARK: - ProjectsViewModel

public protocol ProjectDetailViewModel {
    var project: Project { get }

    func handleProjectDetailPath(_ path: ProjectDetailPath)
}

// MARK: - ProjectsViewModelImpl

@Observable
public class ProjectDetailViewModelImpl: ProjectDetailViewModel {

    // MARK: - Internal properties

    public var project: Project

    private weak var flowDelegate: ProjectDetailFlowDelegate?
    private var projects: [Project] = []

    // MARK: - Initializers

    public init(
        project: Project,
        flowDelegate: ProjectDetailFlowDelegate?
    ) {
        self.project = project
        self.flowDelegate = flowDelegate
    }

    // MARK: - Internal interface

    public func handleProjectDetailPath(_ path: ProjectDetailPath) {
        flowDelegate?.handleProjectDetailPath(path, project: project)
    }
}
