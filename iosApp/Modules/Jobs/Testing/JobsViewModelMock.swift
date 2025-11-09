import Foundation
import shared
import Core

final class JobsViewModelMock: JobsViewModel {

    
    var screenState: JobsScreenState

    init(screenState: JobsScreenState = .loading) {
        self.screenState = screenState
    }

    func onAppear() {}
    func openLink(_ webUrl: String) {}
    func handleAction(_ action: JobsAction) {}
}

#if DEBUG

extension DetailedJob {
    static func mock(
        id: Int64 = 1,
        status: PipelineStatus = .success,
        stage: String? = "build",
        name: String? = "Compile",
        ref: String? = "main",
        webUrl: String? = "https://example.com/job/1",
        user: User? = .mock(),
        createdAt: Kotlinx_datetimeInstant? = Kotlinx_datetimeInstant.Companion().fromEpochMilliseconds(
            epochMilliseconds: Int64(Date().timeIntervalSince1970 * 1000)
        ),
        startedAt: Kotlinx_datetimeInstant? = nil,
        finishedAt: Kotlinx_datetimeInstant? = nil,
        durationSeconds: KotlinDouble? = 75.0
    ) -> DetailedJob {
        DetailedJob(
            id: id,
            status: status,
            stage: stage,
            name: name,
            pipelineName: "💄Oneplay Button",
            ref: ref,
            webUrl: webUrl,
            user: user,
            createdAt: createdAt,
            startedAt: startedAt,
            finishedAt: finishedAt,
            durationSeconds: durationSeconds
        )
    }
}

#endif
