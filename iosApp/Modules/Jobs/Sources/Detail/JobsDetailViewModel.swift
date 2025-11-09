import Foundation
import shared
import Observation
import SwiftUI

// MARK: - JobsViewModel

public protocol JobsDetailViewModel {
    var screenState: JobsDetailScreenState { get }
    var job: DetailedJob { get }

    func onAppear()
    func openLink(_ webUrl: String)
}

// MARK: - ScreenState

public enum JobsDetailScreenState {
    case loading
    case loaded(JobLog)
}

// MARK: - JobsViewModelImpl

@Observable
public class JobsDetailViewModelImpl: JobsDetailViewModel {

    // MARK: - Internal properties

    public var screenState: JobsDetailScreenState = .loading
    public let job: DetailedJob

    private let projectId: KotlinInt
    private let dependencies: JobsDetailViewModelDependencies

    // MARK: - Initializers

    public init(
        dependencies: JobsDetailViewModelDependencies,
        projectId: KotlinInt,
        job: DetailedJob
    ) {
        self.dependencies = dependencies
        self.projectId = projectId
        self.job = job
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

        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    // MARK: - Private helpers

    private func loadData() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            do {
                let jobLog = try await dependencies.getJobLogUseCase.invoke(
                    projectId: Int32(truncating: projectId),
                    jobId: job.id
                )

                screenState = .loaded(jobLog)
            } catch {

            }
        }
    }
}
