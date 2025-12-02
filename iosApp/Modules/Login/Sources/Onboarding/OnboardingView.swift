import SwiftUI
import GitLabourerUI

struct OnboardingView<ViewModel: OnboardingViewModel>: View {

    // MARK: - Properties

    @State private var viewModel: ViewModel
    @State private var selectedIndex: Int = 0

    @Environment(\.dismiss) private var dismiss

    // MARK: - Initializers

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - UI

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(viewModel.data.enumerated()), id: \.offset) { offset, item in
                VStack(spacing: 12) {
                    item.image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)

                    Text(item.title)
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundStyle(GitlabColors.gitlabOrange.swiftUIColor)

                    Text(item.description)
                        .font(.headline)
                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                        .multilineTextAlignment(.center)

                    if offset == 3 {
                        Button {
                            viewModel.openTokenURL()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "link")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 25)

                                Text("How to get your Personal Access token")
                            }
                            .underline()
                        }
                        .foregroundStyle(GitlabColors.gitlabOrangeTwo.swiftUIColor)
                        .padding(.top, 40)
                    }
                }
                .padding(.bottom, 64)
                .padding(.horizontal, 32)
                .tag(offset)
                .safeAreaInset(edge: .bottom) {
                    if offset == 3 {
                        PrimaryButton("Start") {
                            dismiss()
                        }
                    }
                }
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .gitlabourerBackground()
    }
}

#if DEBUG

// MARK: - Previews

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: OnboardingViewModelImpl())
    }
}

#endif
