import Foundation
import shared
import Observation
import SwiftUI

// MARK: - PipelinesViewModel

public protocol PipelinesViewModel {
    var screenState: PipelinesScreenState { get }

    func onAppear()
    func openLink(_ webUrl: String)
    func onPipelineClick(_ pipeline: DetailedPipeline)
}

// MARK: - ScreenState

public enum PipelinesScreenState {
    case loading
    case loaded([DetailedPipeline])
}

// MARK: - PipelinesViewModelImpl

@Observable
public class PipelinesViewModelImpl: PipelinesViewModel {

    // MARK: - Internal properties

    public var screenState: PipelinesScreenState = .loading

    private let projectId: KotlinInt
    private let dependencies: PipelinesViewModelDependencies
    private weak var flowDelegate: PipelinesFlowDelegate?
    private var pageNumber: Int = 0

    // MARK: - Initializers

    public init(
        dependencies: PipelinesViewModelDependencies,
        flowDelegate: PipelinesFlowDelegate?,
        projectId: KotlinInt,
    ) {
        self.dependencies = dependencies
        self.flowDelegate = flowDelegate
        self.projectId = projectId
    }

    // MARK: - Internal interface

    public func onAppear() {
        guard case .loading = screenState else { return }

        loadData()
    }

    public func openLink(_ webUrl: String) {
        guard
            let url = URL(string: webUrl),
            UIApplication.shared.canOpenURL(url)
        else { return }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    public func onPipelineClick(_ pipeline: DetailedPipeline) {
        flowDelegate?.onPipelineClick(pipeline)
    }

    // MARK: - Private helpers

    private func loadData() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            screenState = .loading

            do {
                let fileData = try await dependencies.getPipelinesForProjectUseCase.invoke(
                    projectId: Int32(truncating: projectId),
                    pageNumber: Int32(pageNumber)
                )

                screenState = .loaded(fileData)
            } catch {

            }
        }
    }
}
