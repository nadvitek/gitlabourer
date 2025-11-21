import Foundation
import UIKit
import GitLabourerUI

public protocol OnboardingViewModel {
    var data: [OnboardingModel] { get }

    func openTokenURL()
}

// MARK: - LoginViewModelImpl

@Observable
public class OnboardingViewModelImpl: OnboardingViewModel {

    public var data: [OnboardingModel] = [
        .init(
            title: "GitLabourer",
            description: "Welcome to GitLabourer, your choice for managing your Gitlab repositories.",
            image: GitLabourerUIAsset.logo.swiftUIImage
        ),
        .init(
            title: "Browse projects",
            description: "Search and view any project from your Gitlab. Go through merge requests, repositories, pipelines and jobs.",
            image: GitLabourerUIAsset.onboarding1.swiftUIImage
        ),
        .init(
            title: "Stay notified",
            description: "Stay notified in real time about state of your merge requests pipeline.",
            image: GitLabourerUIAsset.onboarding2.swiftUIImage
        ),
        .init(
            title: "Log in",
            description: "Log in with URL of your Gitlab server and your Personal Access token",
            image: GitLabourerUIAsset.onboarding3.swiftUIImage
        )
    ]

    // MARK: - Initializers

    public init() {}

    // MARK: - Internal interface

    public func openTokenURL() {
        guard
            let url = URL(string: "https://docs.gitlab.com/user/profile/personal_access_tokens/"),
            UIApplication.shared.canOpenURL(url)
        else { return }

        DispatchQueue.main.async {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
