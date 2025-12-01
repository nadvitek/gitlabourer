import SwiftUI
import GitLabourerUI

struct LoginView<ViewModel: LoginViewModel>: View {

    // MARK: - Properties

    @State private var viewModel: ViewModel

    // MARK: - Initialiezers

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - UI

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 0) {
                    GitLabourerUIAsset.logo.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)

                    Text("GitLabourer")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundStyle(GitlabColors.gitlabOrange.swiftUIColor)
                }
                .padding(.top, 40)

                VStack(spacing: 16) {
                    // TODO: - Implement error message
                    GitLabourerTextField(
                        text: $viewModel.url,
                        placeholder: "gitlab.com",
                        errorMessage: .constant("")
                    )

                    GitLabourerTextField(
                        text: $viewModel.token,
                        placeholder: "Personal Access Token",
                        errorMessage: $viewModel.errorMessage
                    )
                }

                PrimaryButton(
                    "Login",
                    isLoading: viewModel.isLoading,
                    action: viewModel.login
                )

                Spacer()

                HStack(spacing: 4) {
                    Text("Above the Mill")
                        .fontWeight(.bold)

                    Image(systemName: "fanblades.fill")
                        .symbolEffect(.rotate.byLayer, options: .repeat(.periodic(delay: 0.0)))
                }
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
            }
            .padding(.horizontal, 16)
        }
        .scrollDisabled(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(
            isPresented: $viewModel.isOnboardingPresented,
            onDismiss: {
                UserDefaults.standard.wasOnboarded = true
            }
        ) {
            OnboardingView(viewModel: OnboardingViewModelImpl())
        }
        .onAppear {
            viewModel.presentOnboarding()
        }
        .gitlabourerBackground()
    }
}

public func createLoginViewController(
    dependencies: LoginViewModelDependencies,
    flowDelegate: LoginFlowDelegate?
) -> UIViewController {
    LoginView(
        viewModel: LoginViewModelImpl(
            dependencies: dependencies,
            flowDelegate: flowDelegate
        )
    )
    .preferredColorScheme(.dark)
    .hosting()
}

#if DEBUG

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModelMock(errorMessage: "Personal Access Token is invalid."))
            .preferredColorScheme(.dark)
    }
}

#endif
