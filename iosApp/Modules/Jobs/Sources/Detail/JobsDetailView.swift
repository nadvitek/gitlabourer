import SwiftUI
import shared
import GitLabourerUI

public struct JobsDetailView<ViewModel: JobsDetailViewModel>: View {

    // MARK: - Properties

    @State private var viewModel: ViewModel

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

    // MARK: - Private helpers

    private var content: some View {
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
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            switch viewModel.screenState {
            case .loading:
                ProgressView()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
            case let .loaded(jobLog):
                loaded(jobLog)
            }
        }
        .padding(.top, 20)
    }

    private func loaded(_ jobLog: JobLog) -> some View {
        ScrollViewThatFits {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    if let name = viewModel.job.name {
                        Text(name)
                            .fontWeight(.bold)
                    }
                }
                .foregroundStyle(GitlabColors.gitlabDark.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
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

                if jobLog.content.isEmpty {
                    Text("This job does not have a trace.")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                } else {
                    let nsAttr = NSAttributedString(string: jobLog.content)
                    let recolored = overridingColor(nsAttr, color: GitlabColors.gitlabGray.color)
                    AttributedText(attributedString: recolored)
                        .foregroundStyle(GitlabColors.gitlabGray.swiftUIColor)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
        }
    }

    private func overridingColor(_ attributed: NSAttributedString, color: UIColor) -> NSAttributedString {
        let mutable = NSMutableAttributedString(attributedString: attributed)
        let fullRange = NSRange(location: 0, length: mutable.length)
        mutable.removeAttribute(.foregroundColor, range: fullRange)
        mutable.addAttribute(.foregroundColor, value: color, range: fullRange)
        return mutable
    }
}

#if DEBUG

// MARK: - Previews

#Preview {
    JobsDetailView(
        viewModel: JobsDetailViewModelMock()
    )
}

#endif
