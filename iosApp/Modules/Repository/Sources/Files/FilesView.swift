import SwiftUI
import shared
import GitLabourerUI

public struct FilesView<ViewModel: FilesViewModel>: View {

    // MARK: - Properties

    @State private var viewModel: ViewModel
    @State private var coppied: Bool = false

    @Environment(\.dismiss) private var dismiss

    // MARK: - Initializers

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - UI

    public var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .preferredColorScheme(.dark)
            .gitlabourerBackground()
            .onAppear(perform: viewModel.onAppear)
    }

    // MARK: -

    private var content: some View {
        ScrollViewThatFits {
            VStack(spacing: 12) {
                HStack(spacing: 6) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 14)
                    }
                    .glassEffect()

                    Spacer()

                    RepositoryBranchPickerView(
                        selectedBranch: $viewModel.selectedBranchName,
                        branches: viewModel.branches
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                switch viewModel.screenState {
                case .loading:
                    ProgressView()
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity
                        )
                case let .loaded(file):
                    loaded(file)
                }
            }
            .padding(.top, 20)
        }
    }

    private func loaded(_ file: FileData) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text(file.fileName)
                    .fontWeight(.bold)

                Spacer()

                HStack(spacing: 8) {
                    if coppied {
                        Image(systemName: "checkmark")
                            .transition(.opacity.combined(with: .scale))
                    }

                    Button {
                        UIPasteboard.general.string = file.content
                        withAnimation(.easeInOut(duration: 0.15)) {
                            coppied = true
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                coppied = false
                            }
                        }
                    } label: {
                        Image(systemName: "document.on.document.fill")
                    }
                }
            }
            .foregroundStyle(GitlabColors.gitlabDark.swiftUIColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(GitlabColors.gitlabGray.swiftUIColor.opacity(0.6))
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 12,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 12,
                    style: .circular
                )
            )

            // Render Markdown with a selectable UITextView wrapper; otherwise use selectable SwiftUI Text
            Group {
                if file.type == .md,
                   let attributed = try? attributedMarkdown(from: file.content) {
                    // Convert to NSAttributedString and override colors
                    let nsAttr = NSAttributedString(attributed)
                    let recolored = overridingColor(nsAttr, color: GitlabColors.gitlabGray.color)
                    AttributedText(attributedString: recolored)
                } else {
                    // Plain text: enable SwiftUI text selection
                    Text(file.content)
                        .textSelection(.enabled)
                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .background(GitlabColors.gitlabDark.swiftUIColor.opacity(0.8))
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 12,
                    bottomTrailingRadius: 12,
                    topTrailingRadius: 0,
                    style: .circular
                )
            )
        }
    }

    // MARK: - Helpers

    private func attributedMarkdown(from content: String) throws -> AttributedString {
        var options = AttributedString.MarkdownParsingOptions()
        options.interpretedSyntax = .inlineOnlyPreservingWhitespace
        return try AttributedString(markdown: content, options: options)
    }

    private func overridingColor(_ attributed: NSAttributedString, color: UIColor) -> NSAttributedString {
        let mutable = NSMutableAttributedString(attributedString: attributed)
        let fullRange = NSRange(location: 0, length: mutable.length)
        mutable.removeAttribute(.foregroundColor, range: fullRange)
        mutable.addAttribute(.foregroundColor, value: color, range: fullRange)
        return mutable
    }
}

struct AttributedText: UIViewRepresentable {
    let attributedString: NSAttributedString

    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.isSelectable = true
        tv.dataDetectorTypes = .link
        tv.backgroundColor = .clear
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        tv.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        tv.textContainer.lineBreakMode = .byWordWrapping

        tv.linkTextAttributes = [
            .foregroundColor: GitlabColors.gitlabOrange.color
        ]
        return tv
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedString
    }

    @available(iOS 16.0, *)
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize {
        let targetWidth = proposal.width ?? UIScreen.main.bounds.width
        let size = uiView.sizeThatFits(CGSize(width: targetWidth, height: .greatestFiniteMagnitude))
        return CGSize(width: targetWidth, height: size.height)
    }
}

#Preview(traits: .landscapeRight) {
    FilesView(
        viewModel: FilesViewModelMock(
            screenState: .loaded(
                .init(
                    fileName: "SomeFile.md",
                    ref: "",
                    content: """
                    O Ackee 📖
                    ======

                    **Ackee** založili Martin Půlpitel, Josef Gattermayer a Dominik Veselý na zkoušku 11. července 2012. Kluci do toho šli s vervou! Hledali si cestičku, zkoušeli vlastní produkty, rvali se s konkurencí. Něco se povedlo, něco ne tak úplně. Ale celkově „pokus“ vyšel a během prvního roku se podařilo firmu stabilizovat, získat spokojené zákazníky a pokračovat v růstu. Časem se ke klukům přidal Honza Mísař, který si koupil svůj podíl ve firmě.



                    V roce 2023 původní vedení předalo štafetu novému vedení - Markovi Přibáňovi, Jiřímu Šmolíkovi a Davidovi Bilíkovi (Honza zůstal). Taky jsme uzavřeli strategické partnerství [s Arbesem](https://www.arbes.com/en/node/214). Ten patří do finanční skupiny Expandia a od celé spolupráce si slibujeme primárně větší stabilitu. Podrobněji jsme se o tom rozespali [tady na webu](https://www.ackee.cz/blog/do-vyvojarskeho-studia-ackee-vstupuje-skupina-expandia).

                    [Kdo (co) dělá v Ackee](https://miro.com/app/board/o9J_kzKzqHo=/)

                    [Role a zodpovědnosti v týmech](https://docs.google.com/document/d/1RId4yFjR_eE40wOxxKv4ZCmfGCMpzRQZ/edit#heading=h.m75fr6wo2w4m)

                    [Matice zodpovědnosti](https://gitlab.ack.ee/Ackee/ackee-hub/-/blob/master/matice_zodpovednosti.md)

                    [Přiřazení projektů](./codelamvackee.md)


                    About Ackee 📖
                    ======

                    **Ackee** was founded on 11th, July 2012 as a trial run by Martin Půlpitel, Josef Gattermayer, and Dominik Veselý. The guys went into it full steam ahead! They were looking for their own path, trying their own products, fighting with competition. Something worked out, other things weren't so smooth. Overall the "experiment" worked out and in the first year the company was stabilized, got its first happy clients and continued to grow.

                    In 2023, the original management handed over the baton to a new team — Marek Přibáň, Jirka Šmolík, and David Bilík (Honza stayed on). We also entered into a strategic partnership with [Arbes](https://www.arbes.com/en/node/214) , which is part of the financial group Expandia. From this collaboration, we mainly expect greater stability. We’ve written more about it in detail here on our [website](https://www.ackee.cz/blog/do-vyvojarskeho-studia-ackee-vstupuje-skupina-expandia).

                    [Who works (on what) in Ackee](https://miro.com/app/board/o9J_kzKzqHo=/)

                    [Matrix of responsibilities](https://gitlab.ack.ee/Ackee/ackee-hub/-/blob/master/matice_zodpovednosti.md)

                    [Allocation to projects](./codelamvackee.md)

                    [Project assignment](https://gitlab.ack.ee/Ackee/ackee-hub/-/blob/master/codelamvackee.md)
                    """
                )
            )
        )
    )
}
