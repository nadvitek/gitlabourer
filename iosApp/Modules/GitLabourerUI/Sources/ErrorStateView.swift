import SwiftUI

public struct ErrorStateView: View {

    // MARK: - Properties

    private let isLoading: Bool
    private let retry: () -> Void

    // MARK: - Initializers

    public init(
        isLoading: Bool,
        retry: @escaping () -> Void
    ) {
        self.isLoading = isLoading
        self.retry = retry
    }

    // MARK: - UI

    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "network.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                .symbolEffect(.bounce)

            PrimaryButton(
                "Retry",
                isLoading: isLoading,
                action: retry
            )
        }
    }
}

#if DEBUG

// MARK: - Previews

#Preview {
    ErrorStateView(
        isLoading: false,
        retry: {}
    )
}

#endif
