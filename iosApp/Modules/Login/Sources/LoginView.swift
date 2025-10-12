import SwiftUI
import GitLabourerUI

public struct LoginView<ViewModel: LoginViewModel>: View {

    // MARK: - Properties

    @State private var viewModel: ViewModel

    // MARK: - Initialiezers

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - UI

    public var body: some View {
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
                    // TODO: - Implement
                    GitLabourerTextField(
                        text: .constant(""),
                        placeholder: "Server address",
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
            }
            .padding(.horizontal, 16)
        }
        .scrollDisabled(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gitlabourerBackground()
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 4) {
                Text("Above the Mill s.r.o.")
                    .fontWeight(.bold)

                Image(systemName: "fanblades.fill")
                    .symbolEffect(.rotate.byLayer, options: .repeat(.periodic(delay: 0.0)))
            }
            .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
            .padding(.bottom, 50)
        }
    }
}

#if DEBUG

#Preview {
    LoginView(viewModel: LoginViewModelMock(errorMessage: "Personal Access Token is invalid."))
}

#endif
