import Foundation
import shared
import Observation
import SwiftUI

// MARK: - FilesViewModel

public protocol FilesViewModel {
    var screenState: FilesScreenState { get }
    var selectedBranchName: String { get set }
    var branches: [String] { get }

    func onAppear()
}

// MARK: - ScreenState

public enum FilesScreenState {
    case loading
    case loaded(FileData)
}

// MARK: - FilesViewModelImpl

@Observable
public class FilesViewModelImpl: FilesViewModel {

    // MARK: - Internal properties

    public var screenState: FilesScreenState = .loading
    public var selectedBranchName: String {
        didSet {
            loadData()
        }
    }
    public var branches: [String] = []

    private let projectId: KotlinInt
    private let filePath: String
    private let dependencies: FilesViewModelDependencies
    private var branchTask: Task<Void, Never>?

    // MARK: - Initializers

    public init(
        dependencies: FilesViewModelDependencies,
        projectId: KotlinInt,
        filePath: String,
        selectedBranchName: String,
        branches: [String]
    ) {
        self.dependencies = dependencies
        self.projectId = projectId
        self.filePath = filePath
        self.selectedBranchName = selectedBranchName
        self.branches = branches
    }

    // MARK: - Internal interface

    public func onAppear() {
        guard case .loading = screenState else { return }

        loadData()
    }

    // MARK: - Private helpers

    private func loadData() {
        branchTask?.cancel()
        branchTask = Task { @MainActor [weak self] in
            guard let self else { return }

            screenState = .loading

            do {
                var fileData = try await dependencies.getFileData.invoke(
                    projectId: Int32(truncating: projectId),
                    filePath: filePath,
                    branchName: selectedBranchName
                )

                screenState = .loaded(fileData)
            } catch {

            }
        }
    }
}

extension FileData {
    enum FileType {
        case md, other
    }

    var type: FileType {
        if fileName.split(separator: ".").last?.lowercased() == "md" {
            .md
        } else {
            .other
        }
    }
}
