import SwiftUI

public enum Size { case small, medium, large }

// MARK: - Morph Text Field

public struct MorphTextField<Leading: View, Trailing: View>: View {
    // Public API

    public enum Variant { case filled, outline }
    public enum ValidationState: Equatable {
        case none
        case error(String)
        case success(String)
    }

    @Binding private var text: String
    @FocusState private var isFocused: Bool
    @State private var isSecureRevealed: Bool = false

    private let title: String?
    private let placeholder: String
    private let helperText: String?
    private let variant: Variant
    private let size: Size
    private let showsClearButton: Bool
    private let isSecure: Bool
    private let maxLength: Int?
    private let counterAlignmentTrailing: Bool
    private let validation: ValidationState
    private let isDisabled: Bool
    private let leading: () -> Leading
    private let trailing: () -> Trailing
    private let onCommit: (() -> Void)?

    // Theme tokens (tweak these to match your Figma)
    private let tokens = Tokens()

    // MARK: - Init

    public init(
        _ title: String? = nil,
        text: Binding<String>,
        placeholder: String = "",
        helperText: String? = nil,
        variant: Variant = .outline,
        size: Size = .medium,
        showsClearButton: Bool = true,
        isSecure: Bool = false,
        maxLength: Int? = nil,
        counterAlignmentTrailing: Bool = true,
        validation: ValidationState = .none,
        isDisabled: Bool = false,
        @ViewBuilder leading: @escaping () -> Leading = { EmptyView() },
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() },
        onCommit: (() -> Void)? = nil
    ) {
        self._text = text
        self.title = title
        self.placeholder = placeholder
        self.helperText = helperText
        self.variant = variant
        self.size = size
        self.showsClearButton = showsClearButton
        self.isSecure = isSecure
        self.maxLength = maxLength
        self.counterAlignmentTrailing = counterAlignmentTrailing
        self.validation = validation
        self.isDisabled = isDisabled
        self.leading = leading
        self.trailing = trailing
        self.onCommit = onCommit
    }

    // MARK: - Body

    public var body: some View {
        let metrics = tokens.metrics(for: size)
        let effectiveText = Binding<String>(get: { text }, set: { newValue in
            if let max = maxLength {
                text = String(newValue.prefix(max))
            } else {
                text = newValue
            }
        })

        let status = fieldStatus

        return VStack(spacing: 6) {
            // Container
            ZStack(alignment: .leading) {
                background
                    .overlay(border(status: status))
                    .clipShape(RoundedRectangle(cornerRadius: metrics.cornerRadius, style: .continuous))

                HStack(spacing: 8) {
                    leading()
                        .frame(width: metrics.iconSquare, height: metrics.iconSquare)
                        .opacity(isPlaceholderOnly ? 0.6 : 1)

                    ZStack(alignment: .leading) {
                        // Floating title / label
                        if let title { labelView(title: title, metrics: metrics, status: status) }

                        // Placeholder (when no title configured)
                        if title == nil {
                            Text(placeholder)
                                .foregroundStyle(tokens.placeholderColor)
                                .font(metrics.font)
                                .opacity(text.isEmpty ? 1 : 0)
                                .accessibilityHidden(true)
                        }

                        // Field
                        Group {
                            if isSecure && !isSecureRevealed {
                                SecureField("", text: effectiveText)
                                    .textInputAutocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .focused($isFocused)
                                    .onSubmit { onCommit?() }
                            } else {
                                TextField("", text: effectiveText, onEditingChanged: { _ in }, onCommit: { onCommit?() })
                                    .focused($isFocused)
                            }
                        }
                        .frame(minHeight: metrics.textLineHeight)
                        .padding(.top, (title != nil) ? metrics.floatingTopPadding : 0)
                        .font(metrics.font)
                        .foregroundStyle(isDisabled ? tokens.disabledText : tokens.text)
                        .accessibilityLabel(Text(title ?? placeholder))
                        .disabled(isDisabled)
                    }

                    Spacer(minLength: 0)

                    HStack(spacing: 6) {
                        // Clear button
                        if showsClearButton && !text.isEmpty && !isDisabled {
                            Button(action: { withAnimation(.easeOut(duration: 0.12)) { text = "" } }) {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: metrics.iconSquare, height: metrics.iconSquare)
                                    .opacity(0.6)
                                    .accessibilityLabel("Clear text")
                            }
                        }
                        // Secure toggle
                        if isSecure {
                            Button(action: { withAnimation(.easeInOut(duration: 0.15)) { isSecureRevealed.toggle() } }) {
                                Image(systemName: isSecureRevealed ? "eye.slash" : "eye")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: metrics.iconSquare, height: metrics.iconSquare)
                                    .opacity(0.8)
                            }
                            .accessibilityLabel(isSecureRevealed ? "Hide password" : "Show password")
                        }

                        trailing()
                            .frame(width: metrics.iconSquare, height: metrics.iconSquare)
                    }
                }
                .padding(.horizontal, metrics.horizontalPadding)
                .padding(.vertical, metrics.verticalPadding)
            }
            .animation(.easeInOut(duration: 0.16), value: isFocused)
            .animation(.easeInOut(duration: 0.16), value: validation)

            // Helper / validation and counter
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Group {
                    switch validation {
                    case .none:
                        if let helperText, !helperText.isEmpty {
                            Text(helperText)
                                .foregroundStyle(tokens.helper)
                                .font(tokens.helperFont)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    case .error(let message):
                        Label(message, systemImage: "exclamationmark.circle")
                            .labelStyle(.titleAndIcon)
                            .foregroundStyle(tokens.error)
                            .font(tokens.helperFont)
                    case .success(let message):
                        Label(message, systemImage: "checkmark.circle")
                            .labelStyle(.titleAndIcon)
                            .foregroundStyle(tokens.success)
                            .font(tokens.helperFont)
                    }
                }
                Spacer()
                if let max = maxLength {
                    let counter = "\(text.count)/\(max)"
                    Text(counter)
                        .foregroundStyle(tokens.counter)
                        .font(tokens.helperFont)
                        .accessibilityLabel("Character count \(counter)")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .onChange(of: isFocused) { _ in }
    }

    // MARK: - Subviews

    private var isPlaceholderOnly: Bool { title == nil && text.isEmpty }

    private func labelView(title: String, metrics: Metrics, status: FieldVisualStatus) -> some View {
        let topPadding = (text.isEmpty && !isFocused) ? 0 : metrics.floatingTopPadding
        let scale: CGFloat = (text.isEmpty && !isFocused) ? 1.0 : 0.82
        let color: Color = {
            if isDisabled { return tokens.disabledText }
            switch status {
            case .error: return tokens.error
            case .success: return tokens.success
            case .focused: return tokens.accent
            default: return tokens.label
            }
        }()
        return Text(title)
            .font(metrics.font)
            .foregroundStyle(color)
            .scaleEffect(scale, anchor: .leading)
            .padding(.top, topPadding)
            .animation(.spring(response: 0.24, dampingFraction: 0.9, blendDuration: 0.12), value: text)
            .animation(.spring(response: 0.24, dampingFraction: 0.9, blendDuration: 0.12), value: isFocused)
            .accessibilityHidden(true)
    }

    private var background: some View {
        let bg: Color
        switch variant {
        case .filled:
            bg = tokens.fill
        case .outline:
            bg = tokens.background
        }
        return RoundedRectangle(cornerRadius: tokens.baseCorner, style: .continuous)
            .fill(bg)
            .opacity(isDisabled ? 0.6 : 1)
    }

    private var fieldStatus: FieldVisualStatus {
        if isDisabled { return .disabled }
        switch validation {
        case .error: return .error
        case .success: return .success
        case .none: return isFocused ? .focused : .normal
        }
    }

    @ViewBuilder
    private func border(status: FieldVisualStatus) -> some View {
        switch variant {
        case .outline:
            RoundedRectangle(cornerRadius: tokens.baseCorner, style: .continuous)
                .strokeBorder(tokens.borderColor(for: status), lineWidth: tokens.borderWidth(for: status))
                .shadow(color: tokens.shadowColor(for: status), radius: tokens.shadowRadius(for: status), x: 0, y: tokens.shadowYOffset(for: status))
        case .filled:
            RoundedRectangle(cornerRadius: tokens.baseCorner, style: .continuous)
                .strokeBorder(tokens.borderColor(for: status), lineWidth: tokens.borderWidth(for: status))
        }
    }
}

public enum FieldVisualStatus { case normal, focused, error, success, disabled }

// MARK: - Tokens
private struct Tokens {
    // Colors – tune to match your DS
    let background = Color(.systemBackground)
    let fill = Color(.secondarySystemFill)
    let text = Color.primary
    let label = Color.secondary
    let placeholderColor = Color.secondary.opacity(0.6)
    let helper = Color.secondary
    let counter = Color.secondary
    let accent = Color.accentColor
    let error = Color(red: 0.92, green: 0.18, blue: 0.24) // tweak
    let success = Color(red: 0.0, green: 0.62, blue: 0.35) // tweak
    let disabledText = Color.secondary.opacity(0.6)

    let helperFont = Font.footnote
    let baseCorner: CGFloat = 12

    func borderColor(for status: FieldVisualStatus) -> Color {
        switch status {
        case .error: return error
        case .success: return success
        case .focused: return accent
        case .disabled: return Color.secondary.opacity(0.25)
        default: return Color.secondary.opacity(0.35)
        }
    }

    func borderWidth(for status: FieldVisualStatus) -> CGFloat {
        switch status {
        case .focused: return 1.5
        case .error, .success: return 1.5
        default: return 1
        }
    }

    func shadowColor(for status: FieldVisualStatus) -> Color {
        switch status {
        case .focused: return Color.black.opacity(0.06)
        case .error: return error.opacity(0.12)
        case .success: return success.opacity(0.12)
        default: return .clear
        }
    }

    func shadowRadius(for status: FieldVisualStatus) -> CGFloat {
        switch status {
        case .focused, .error, .success: return 6
        default: return 0
        }
    }

    func shadowYOffset(for status: FieldVisualStatus) -> CGFloat {
        switch status {
        case .focused, .error, .success: return 2
        default: return 0
        }
    }

    func metrics(for size: Size) -> Metrics {
        switch size {
        case .small: return Metrics(font: .subheadline, textLineHeight: 18, horizontalPadding: 10, verticalPadding: 8, cornerRadius: 10, iconSquare: 16, floatingTopPadding: 12)
        case .medium: return Metrics(font: .body, textLineHeight: 20, horizontalPadding: 12, verticalPadding: 10, cornerRadius: 12, iconSquare: 18, floatingTopPadding: 14)
        case .large: return Metrics(font: .title3, textLineHeight: 22, horizontalPadding: 14, verticalPadding: 12, cornerRadius: 14, iconSquare: 20, floatingTopPadding: 16)
        }
    }
}

private struct Metrics {
    let font: Font
    let textLineHeight: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let cornerRadius: CGFloat
    let iconSquare: CGFloat
    let floatingTopPadding: CGFloat
}

// Helper placeholder to satisfy generic defaults in Tokens
public struct FieldPlaceholder: View { public var body: some View { EmptyView() } }

// MARK: - Convenience API (non-generic)
public extension MorphTextField where Leading == FieldPlaceholder, Trailing == FieldPlaceholder {
    init(
        _ title: String? = nil,
        text: Binding<String>,
        placeholder: String = "",
        helperText: String? = nil,
        variant: Variant = .outline,
        size: Size = .medium,
        showsClearButton: Bool = true,
        isSecure: Bool = false,
        maxLength: Int? = nil,
        counterAlignmentTrailing: Bool = true,
        validation: ValidationState = .none,
        isDisabled: Bool = false,
        onCommit: (() -> Void)? = nil
    ) {
        self.init(title, text: text, placeholder: placeholder, helperText: helperText, variant: variant, size: size, showsClearButton: showsClearButton, isSecure: isSecure, maxLength: maxLength, counterAlignmentTrailing: counterAlignmentTrailing, validation: validation, isDisabled: isDisabled, leading: { FieldPlaceholder() }, trailing: { FieldPlaceholder() }, onCommit: onCommit)
    }
}

// MARK: - Preview / Demo
struct MorphTextField_Previews: PreviewProvider {
    struct Demo: View {
        @State private var text1 = ""
        @State private var text2 = "john.doe@example.com"
        @State private var pass = "hunter2"
        @State private var disabledText = "Disabled"
        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    Group {
                        MorphTextField("Email", text: $text1, placeholder: "Enter your email", helperText: "We'll never share your email.", variant: .outline, size: .medium, maxLength: 40)

                        MorphTextField("Email", text: $text2, placeholder: "Enter your email", validation: .error("Invalid email address"))

                        MorphTextField("Password", text: $pass, placeholder: "Minimum 8 characters", variant: .filled, isSecure: true, validation: .success("Strong password"))
                    }

                    MorphTextField("Search", text: $text1, placeholder: "Search", variant: .filled, size: .small) {
                        Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    } trailing: {
                        Image(systemName: "mic.fill").foregroundStyle(.secondary)
                    }

                    MorphTextField("Disabled", text: $disabledText, placeholder: "", isDisabled: true)
                }
                .padding()
            }
        }
    }

    static var previews: some View {
        Demo()
            .previewLayout(.sizeThatFits)
    }
}

