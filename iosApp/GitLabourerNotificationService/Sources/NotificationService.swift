import UserNotifications
import ActivityKit
import Core

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        let content = (request.content.mutableCopy() as? UNMutableNotificationContent)
        self.bestAttemptContent = content

        print("Did receive in NotificationService")

        guard let content else {
            contentHandler(request.content)
            return
        }

        let userInfo = content.userInfo

        if let payload = decodeNotificationPayload(from: userInfo) {
            Task {
                await handleMRPipelineNotification(payload)
            }
        }

        contentHandler(content)
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler, let bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    private func decodeNotificationPayload(from userInfo: [AnyHashable: Any]) -> NotificationPayload? {
        do {
            let data = try JSONSerialization.data(withJSONObject: userInfo, options: [])
            return try JSONDecoder().decode(NotificationPayload.self, from: data)
        } catch {
            print("Failed to decode notification payload:", error)
            return nil
        }
    }

    private func handleMRPipelineNotification(_ payload: NotificationPayload) async {
        print("handleMRPipelineNotification in NotificationService")
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            return
        }

        let existingActivity = Activity<MRPipelineActivityAttributes>.activities.first {
            $0.attributes.projectId == payload.mr.projectId &&
            $0.attributes.mrIID == payload.mr.iid
        }

        print("I am through! in NotificationService")

        let contentState = MRPipelineActivityAttributes.ContentState(
            pipelineId: payload.pipeline.id,
            pipelineStatus: payload.pipeline.status,
            mrTitle: payload.mr.title,
            projectId: payload.mr.projectId,
            mrIID: payload.mr.iid
        )

        let activityContent = ActivityContent(state: contentState, staleDate: nil)

        if let activity = existingActivity {
            await activity.update(activityContent)

            if ["success", "passed", "failed", "canceled"].contains(payload.pipeline.status.lowercased()) {
                try? await Task.sleep(for: .seconds(10))
                await activity.end(activityContent, dismissalPolicy: .immediate)
            }
        } else {
            let attributes = MRPipelineActivityAttributes(
                projectId: payload.mr.projectId,
                mrIID: payload.mr.iid,
                mrTitle: payload.mr.title
            )

            do {
                _ = try Activity.request(
                    attributes: attributes,
                    content: activityContent
                )
            } catch {
                print("Failed to start Live Activity:", error)
            }
        }
    }
}
