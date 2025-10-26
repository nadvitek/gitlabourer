import SwiftUI
import shared

extension PipelineStatus {
    var foregroundColor: Color {
        switch self {
        case .success:
            GitlabColors.success.swiftUIColor
        case .failed:
            GitlabColors.fail.swiftUIColor
        case .running:
            GitlabColors.running.swiftUIColor
        case .canceled, .created, .skipped:
            GitlabColors.cancel.swiftUIColor
        case .pending:
            GitlabColors.gitlabOrange.swiftUIColor.opacity(0.6)
        default:
            .brown
        }
    }

    var icon: Image {
        switch self {
        case .success:
            Image(systemName: "checkmark.circle")
        case .failed:
            Image(systemName: "xmark.circle")
        case .running:
            Image(systemName: "timer.circle")
        case .canceled:
            Image(systemName: "minus.circle")
        case .created:
            Image(systemName: "record.circle")
        case .pending:
            Image(systemName: "pause.circle")
        case .skipped:
            Image(systemName: "forward.end.circle")
        default:
            Image(systemName: "plus")
        }
    }

    var rotation: CGFloat {
        switch self {
        case .canceled:
            45
        default:
            0
        }
    }
}

public struct JobStateView: View {

    private let state: PipelineStatus

    public init(state: PipelineStatus) {
        self.state = state
    }

    public var body: some View {
        state.icon
            .resizable()
            .scaledToFit()
            .foregroundStyle(state.foregroundColor)
            .background(state.foregroundColor.opacity(0.2))
            .clipShape(.circle)
            .rotationEffect(.degrees(state.rotation))
    }
}

#Preview {
    VStack(spacing: 20) {
        JobStateView(state: .success)
        JobStateView(state: .failed)
        JobStateView(state: .running)
        JobStateView(state: .canceled)
        JobStateView(state: .created)
        JobStateView(state: .pending)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .gitlabourerBackground()
    .preferredColorScheme(.dark)
}
