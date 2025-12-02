import Foundation
import shared

final class JobsDetailViewModelMock: JobsDetailViewModel {
    var screenState: JobsDetailScreenState
    var job: DetailedJob
    var isRetryLoading: Bool = false
    var attributedLog: NSAttributedString? = nil

    init(
        screenState: JobsDetailScreenState = .loaded(
            JobLog(
                jobId: 0,
                content: """
            Running with gitlab-runner 18.5.0 (bda84871)
                on Mackee FG98Dznw5, system ID: s_375b4a11b32f
              Preparing the "custom" executor
              00:13
              Using Custom executor with driver tart 1.26.0-404bafe...
              2025/12/02 11:58:31 Pulling the latest version of registry.hub.docker.com/ackee/tart-gitlab-builder-ios:v26...
              2025/12/02 11:58:32 Cloning and configuring a new VM...
              2025/12/02 11:58:32 Waiting for the VM to boot and be SSH-able...
              2025/12/02 11:58:44 Was able to SSH!
              2025/12/02 11:58:44 VM is ready.
              Preparing environment
              00:03
              Running on Manageds-Virtual-Machine.local...
              Getting source from Git repository
              00:18
              Gitaly correlation ID: 01KBFBDH3XM14YWQ4XJQKMPDC6
              Fetching changes with git depth set to 10...
              Reinitialized existing Git repository in /Volumes/AckeeCI/isnemovna/isnemovna-mobile-app/.git/
              Created fresh repository.
              failed to store: -25308
              Checking out 62df7a3f as detached HEAD (ref is refs/merge-requests/5/head)...
              Removing iosApp/Tuist/.build/
              Removing iosApp/cache/
              Updating/initializing submodules recursively with git depth set to 10...
              Updated submodules
              Executing "step_script" stage of the job script
              07:05
              WARNING: Starting with version 17.0 the 'build_script' stage will be replaced with 'step_script': https://gitlab.com/groups/gitlab-org/-/epics/6112
            """
            )
        ),
        job: DetailedJob = .mock()
    ) {
        self.screenState = screenState
        self.job = job
    }

    func onAppear() {}
    func openLink(_ webUrl: String) {}
    func retry() {}
}
