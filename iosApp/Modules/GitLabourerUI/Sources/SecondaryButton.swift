import SwiftUI

public struct SecondaryButton: View {

    // MARK: - Private properties

    private let text: String
    private let isLoading: Bool
    private let action: () -> Void

    // MARK: - Initializers

    public init(
        _ text: String,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.isLoading = isLoading
        self.action = action
    }

    // MARK: - UI

    public var body: some View {
        Button(action: action) {
            Text(text)
                .opacity(isLoading ? 0 : 1)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(GitlabColors.gitlabGray.swiftUIColor.opacity(0.1))
                .clipShape(.rect(cornerRadius: 12))
                .disabled(isLoading)
                .overlay {
                    if isLoading {
                        ProgressView()
                    }
                }
        }
    }
}

#if DEBUG

// MARK: - Previews

struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SecondaryButton("Secondary Button") {}

            SecondaryButton("Very very very long text on Button") {}
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gitlabourerBackground()
        .preferredColorScheme(.dark)
    }
}

#endif
