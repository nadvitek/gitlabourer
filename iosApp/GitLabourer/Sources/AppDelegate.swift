import Foundation
import ActivityKit
import UIKit
import Core
import shared

@main
final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        let orientations: UIInterfaceOrientationMask = UIDevice.current.userInterfaceIdiom == .pad ? .all : [.portrait, .landscape]
        return orientations
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error = error {
                print("Notification auth error: \(error)")
                return
            }

            guard granted else {
                print("User denied notification permission")
                return
            }

            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }

        KoinKt.doInitKoin(extraModules: [])
        return true
    }

    // Called when APNs successfully registers the device
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("APNs device token:", tokenString)

        Task {
            do {
                try await appDependency.saveDeviceTokenUseCase.invoke(deviceToken: tokenString)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register for remote notifications: \(error)")
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        completionHandler(.newData)
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        completionHandler()
    }

    private func decodeNotificationPayload(from userInfo: [AnyHashable: Any]) -> NotificationPayload? {
        do {
            let data = try JSONSerialization.data(withJSONObject: userInfo, options: [])
            return try JSONDecoder().decode(NotificationPayload.self, from: data)
        } catch {
            return nil
        }
    }

    private func handleMRPipelineNotification(_ payload: NotificationPayload) async {
        // Check if there is already an activity for this MR
        let existingActivity = Activity<MRPipelineActivityAttributes>.activities.first {
            $0.attributes.projectId == payload.mr.projectId &&
            $0.attributes.mrIID == payload.mr.iid
        }

        let contentState = MRPipelineActivityAttributes.ContentState(
            pipelineId: payload.pipeline.id,
            pipelineStatus: payload.pipeline.status,
            mrTitle: payload.mr.title,
            projectId: payload.mr.projectId,
            mrIID: payload.mr.iid
        )

        // Wrap state in ActivityContent for iOS 17+ API
        let activityContent = ActivityContent(state: contentState, staleDate: nil)

        if let activity = existingActivity {
            // Update current Live Activity
            await activity.update(activityContent)

            // Optional: if the pipeline is finished, end the activity
            if ["success", "passed", "failed", "canceled"].contains(payload.pipeline.status.lowercased()) {
                try? await Task.sleep(for: .seconds(10))
                await activity.end(activityContent, dismissalPolicy: .immediate)
            }
        } else {
            // Start new Live Activity
            let attributes = MRPipelineActivityAttributes(
                projectId: payload.mr.projectId,
                mrIID: payload.mr.iid,
                mrTitle: payload.mr.title
            )

            do {
                // If you want push-based updates from the backend, use pushType: .token
                let activity = try Activity.request(
                    attributes: attributes,
                    content: activityContent
                )

                print("Started Live Activity id:", activity.id)
            } catch {
                print("Failed to start Live Activity:", error)
            }
        }
    }
}
