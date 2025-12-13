import ActivityKit
import WidgetKit
import SwiftUI
import Core

public struct MRPipelineLiveActivity: Widget {

    public init() {}

    public var body: some WidgetConfiguration {
        ActivityConfiguration(for: MRPipelineActivityAttributes.self) { context in
            // Lock screen / banner UI
            LockScreenView(
                attributes: context.attributes,
                state: context.state
            )
            .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded regions
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("#\(context.attributes.mrIID)")
                            .font(.caption)
                        Text(context.state.pipelineStatus.capitalized)
                            .font(.subheadline)
                            .bold()
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    Text("Pipeline #\(context.state.pipelineId)")
                        .font(.caption)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.attributes.mrTitle)
                        .font(.subheadline)
                        .lineLimit(2)
                }
            } compactLeading: {
                Text("MR")
                    .font(.caption2)
            } compactTrailing: {
                Text(shortStatus(for: context.state.pipelineStatus))
                    .font(.caption2)
            } minimal: {
                Circle()
                    .fill(statusColor(for: context.state.pipelineStatus))
                    .frame(width: 12, height: 12)
            }
        }
    }
}

// MARK: - Extracted Views

private struct LockScreenView: View {
    let attributes: MRPipelineActivityAttributes
    let state: MRPipelineActivityAttributes.ContentState

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(attributes.mrTitle)
                    .font(.headline)
                    .lineLimit(1)

                Text("Pipeline #\(state.pipelineId)")
                    .font(.subheadline)

                Text(state.pipelineStatus.capitalized)
                    .font(.subheadline)
                    .bold()
            }

            Spacer()

            Text(state.pipelineStatus.uppercased())
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor(for: state.pipelineStatus))
                .cornerRadius(10)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Helpers

private func statusColor(for status: String) -> Color {
    switch status.lowercased() {
    case "running":
        return .orange
    case "success", "passed":
        return .green
    case "failed":
        return .red
    case "canceled", "skipped":
        return .gray
    default:
        return .blue
    }
}

private func shortStatus(for status: String) -> String {
    switch status.lowercased() {
    case "running": return "▶︎"
    case "success", "passed": return "✓"
    case "failed": return "✗"
    case "canceled": return "⏹"
    default: return "•"
    }
}

#if DEBUG
@available(iOS 16.1, *)
struct MRPipelineLiveActivity_Previews: PreviewProvider {

    static var attributes: MRPipelineActivityAttributes {
        MRPipelineActivityAttributes(
            projectId: 987,
            mrIID: 42,
            mrTitle: "Fix login crash on iOS"
        )
    }

    static var runningState: MRPipelineActivityAttributes.ContentState {
        .init(
            pipelineId: 1234,
            pipelineStatus: "running",
            mrTitle: attributes.mrTitle,
            projectId: attributes.projectId,
            mrIID: attributes.mrIID
        )
    }

    static var successState: MRPipelineActivityAttributes.ContentState {
        .init(
            pipelineId: 1234,
            pipelineStatus: "success",
            mrTitle: attributes.mrTitle,
            projectId: attributes.projectId,
            mrIID: attributes.mrIID
        )
    }

    static var previews: some View {
        Group {
            LockScreenView(attributes: attributes, state: runningState)
                .previewDisplayName("Lock Screen - Running")
                .padding()

            LockScreenView(attributes: attributes, state: successState)
                .previewDisplayName("Lock Screen - Success")
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
