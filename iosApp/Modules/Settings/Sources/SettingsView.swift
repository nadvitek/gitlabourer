import SwiftUI
import Core
import GitLabourerUI

public struct SettingsView<ViewModel: SettingsViewModel>: View {

    // MARK: - Properties

    @State private var viewModel: ViewModel

    // MARK: - Initializers

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - UI

    public var body: some View {
        VStack(spacing: 0) {
            if let user = viewModel.user {
                VStack(spacing: 24) {
                    userComponent(user.name.getNameInitials())

                    VStack(spacing: 18) {
                        Text(user.name)
                            .multilineTextAlignment(.center)
                            .bold()

                        VStack(spacing: 6) {
                            Text(user.username)

                            if let email = user.email {
                                Text(email)
                            }
                        }
                        .font(.subheadline)
                    }
                }
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
            }

            Spacer()

            PrimaryButton(
                "Logout",
                action: viewModel.logout
            )
        }
        .padding(.top, 20)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItemTransparent(placement: .principal) {
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
            }
        }
        .gitlabourerBackground()
        .onAppear(perform: viewModel.onAppear)
    }

    private func userComponent(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 80, weight: .bold))
            .foregroundStyle(GitlabColors.gitlabDark.swiftUIColor)
            .padding(30)
            .background(GitlabColors.gitlabGray.swiftUIColor)
            .clipShape(.circle)
    }
}

#if DEBUG

// MARK: - Previews

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModelMock())
            .preferredColorScheme(.dark)
    }
}

#endif
