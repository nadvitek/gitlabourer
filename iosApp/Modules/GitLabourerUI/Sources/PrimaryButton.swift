import SwiftUI

public struct PrimaryButton: View {
    
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
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(GitlabColors.gitlabDark.swiftUIColor)
                .lineLimit(1)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .frame(minWidth: 150)
                .background(GitlabColors.gitlabOrangeTwo.swiftUIColor)
                .clipShape(.rect(cornerRadius: 20))
                .disabled(isLoading)
                .overlay {
                    if isLoading {
                        ProgressView()
                    }
                }
        }
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PrimaryButton("Primary Button") {}
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GitlabColors.gitlabDark.swiftUIColor)
    }
}
