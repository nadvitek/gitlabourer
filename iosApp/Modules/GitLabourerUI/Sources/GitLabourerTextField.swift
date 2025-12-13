import SwiftUI

public struct GitLabourerTextField<Trailing: View>: View {

    @Binding private var text: String
    @Binding private var errorMessage: String
    @FocusState private var isFocused: Bool

    private let placeholder: String
    private let trailing: () -> Trailing

    // MARK: - Init

    public init(
        text: Binding<String>,
        placeholder: String,
        errorMessage: Binding<String>,
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
    ) {
        self._text = text
        self.placeholder = placeholder
        self._errorMessage = errorMessage
        self.trailing = trailing
    }

    public var body: some View {
        VStack(spacing: 8) {
            TextField(placeholder, text: $text, prompt: prompt)
                .focused($isFocused)
                .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                .tint(GitlabColors.gitlabGray.swiftUIColor)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.leading, 16)
                .padding(.vertical, 14)
                .background(GitlabColors.gitlabDark.swiftUIColor)
                .clipShape(.rect(cornerRadius: 16))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(errorMessage.isEmpty ? GitlabColors.gitlabGray.swiftUIColor : .red, lineWidth: 2)
                }
                .animation(.default, value: isFocused)
                .onTapGesture { isFocused = true }

            if !errorMessage.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "xmark.octagon.fill")

                    Text(errorMessage)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 12)
                .foregroundStyle(.red)
            }
        }
        .animation(.default, value: errorMessage)
        .onChange(of: isFocused) { oldValue, newValue in
            if newValue {
                errorMessage = ""
            }
        }
    }

    private var prompt: Text {
        Text(placeholder)
            .foregroundStyle(.gray)
    }
}

#if DEBUG

// MARK: - Previews

struct GitLabourerTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            GitLabourerTextField(
                text: .constant(""),
                placeholder: "Private access token",
                errorMessage: .constant("")
            )

            GitLabourerTextField(
                text: .constant("Something"),
                placeholder: "Private access token",
                errorMessage: .constant("")
            )

            GitLabourerTextField(
                text: .constant("Something"),
                placeholder: "Private access token",
                errorMessage: .constant("Error")
            )
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gitlabourerBackground()
    }
}

#endif
