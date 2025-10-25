import Foundation
import shared
import Observation
import SwiftUI

// MARK: - RepositoryViewModel

public protocol RepositoryViewModel {
    var screenState: RepositoryScreenState { get }
    var expanded: Set<TreeItem> { get }
    var scrollViewAxes: Axis.Set { get }
    var itemSize: CGSize { get set }
    var contentHeight: Double { get }
    var selectedBranchName: String { get set }
    var branches: [String] { get }

    func onAppear()
    func onRowClick(_ item: TreeItem)
    func assignItemSize(_ size: CGSize)
}

// MARK: - ScreenState

public enum RepositoryScreenState {
    case loading
    case loaded([TreeItem])
}

// MARK: - RepositoryViewModelImpl

@Observable
public class RepositoryViewModelImpl: RepositoryViewModel {

    // MARK: - Internal properties

    public var screenState: RepositoryScreenState = .loading

    public var expanded: Set<TreeItem> = []
    public var scrollViewAxes: Axis.Set {
        expanded.isEmpty ? [.vertical] : [.vertical, .horizontal]
    }

    public var itemSize: CGSize = .zero

    public var contentHeight: Double {
        guard case let .loaded(items) = screenState else { return 0 }
        return CGFloat(items.count) * itemSize.height
    }
    public var selectedBranchName: String {
        didSet {
            loadDataForSelectedBranchName()
        }
    }
    public var branches: [String] = []

    private var visibleItems: Int {
        itemCount + expanded.map(\.children).count
    }
    private var itemCount: Int = 0
    private let project: Project
    private let dependencies: RepositoryViewModelDependencies
    private weak var flowDelegate: RepositoryFlowDelegate?
    private var branchTask: Task<Void, Never>?

    // MARK: - Initializers

    public init(
        dependencies: RepositoryViewModelDependencies,
        flowDelegate: RepositoryFlowDelegate?,
        project: Project
    ) {
        self.dependencies = dependencies
        self.flowDelegate = flowDelegate
        self.project = project
        self.selectedBranchName = project.defaultBranch ?? ""
    }

    // MARK: - Internal interface

    public func onAppear() {
        loadData()
    }

    public func onRowClick(_ item: TreeItem) {
        if item.kind == .directory {
            if expanded.contains(item) {
                expanded.remove(item)
            } else {
                expanded.insert(item)
            }
        }
    }

    public func assignItemSize(_ size: CGSize) {
        itemSize = size
    }

    // MARK: - Private helpers

    private func loadData() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                let projectId = KotlinInt(value: project.id)

                let branches = try await dependencies.getRepositoryBranchesUseCase.invoke(
                    projectId: projectId
                )

                self.branches = branches.map(\.name)

                let repository = try await dependencies.getRepositoryFileTreeUseCase.invoke(
                    projectId: projectId,
                    branchName: nil
                )

                itemCount = repository.count
                screenState = .loaded(repository)
            } catch {

            }
        }
    }

    private func loadDataForSelectedBranchName() {
        branchTask?.cancel()
        branchTask = Task { @MainActor [weak self] in
            guard let self else { return }

            screenState = .loading

            do {
                let projectId = KotlinInt(value: project.id)

                let repository = try await dependencies.getRepositoryFileTreeUseCase.invoke(
                    projectId: projectId,
                    branchName: selectedBranchName
                )

                itemCount = repository.count
                screenState = .loaded(repository)
            } catch {

            }

        }
    }
}
