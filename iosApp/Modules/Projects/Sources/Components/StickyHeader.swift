import SwiftUI

struct StickyHeaderListView: View {
    // Tunables
    private let baseHeaderHeight: CGFloat = 260
    private let headerMinHeight: CGFloat = 120
    private let horizontalPadding: CGFloat = 16

    // Scroll state
    @State private var scrollOffset: CGFloat = 0

    var body: some View {
        ZStack(alignment: .top) {

            // MARK: Sticky + Stretchy Header
            HeaderView(height: headerHeight, collapsed: isCollapsed)
                // Keep the visual top of the header "pinned" as content scrolls up
                .offset(y: headerPinOffset)
                .zIndex(1)

            // MARK: List Content
            ScrollView(.vertical) {
                // Spacer to let content start below the header
                Color.clear
                    .frame(height: baseHeaderHeight)
                    .frame(maxWidth: .infinity)

                VStack(spacing: 12) {
                    ForEach(MockItem.samples) { item in
                        RowCard(item: item)
                            .padding(.horizontal, horizontalPadding)
                    }
                    .padding(.bottom, 24)
                }
                // Track scroll offset (y is negative when scrolled up, positive when pulling down)
                .onScrollGeometryChange(for: CGFloat.self) { proxy in
                    proxy.contentOffset.y
                } action: { oldValue, newValue in
                    scrollOffset = newValue
                }
            }
            .ignoresSafeArea(edges: .top)
            .scrollIndicators(.hidden)
        }
        .background(Color(.systemBackground))
    }

    // MARK: Derived header values
    private var isCollapsed: Bool {
        // When scrolled up past zero, collapse proportionally until min height is reached
        let collapsedHeight = max(headerMinHeight, baseHeaderHeight + scrollOffset)
        return collapsedHeight <= headerMinHeight + 0.5
    }

    private var headerHeight: CGFloat {
        // Stretch when pulling down (scrollOffset > 0), collapse when scrolling up
        let stretched = baseHeaderHeight + max(0, scrollOffset)    // stretch only on pull-down
        let collapsed = baseHeaderHeight + min(0, scrollOffset)    // collapse when scrolling up
        // Choose collapsed if we're going up, otherwise stretched
        return (scrollOffset < 0) ? max(headerMinHeight, collapsed) : stretched
    }

    private var headerPinOffset: CGFloat {
        // As we scroll up (negative), visually keep the header’s top stuck to the top
        // by moving it up the same amount, but never more than the difference between
        // base and current height (prevents gaps during stretch).
        let up = min(0, scrollOffset)
        let maxTranslate = baseHeaderHeight - headerHeight
        return up - maxTranslate
    }
}

// MARK: - Header
private struct HeaderView: View {
    let height: CGFloat
    let collapsed: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Replace with your asset name if you have one
            LinearGradient(colors: [
                Color.accentColor.opacity(0.9),
                Color.accentColor.opacity(0.6)
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay(
                // Example image overlay to mimic a hero/header
                Image(systemName: "rectangle.stack.fill")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.15)
                    .padding(40)
                    .blendMode(.overlay),
                alignment: .center
            )

            VStack(alignment: .leading, spacing: 8) {
                Text("Sticky & Stretchy Header")
                    .font(.system(size: collapsed ? 24 : 34, weight: .bold))
                    .lineLimit(1)

                Text("SwiftUI Custom List View")
                    .font(.system(size: collapsed ? 13 : 16, weight: .semibold))
                    .opacity(0.9)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16 + (collapsed ? 0 : 8))
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipped()
        .contentShape(Rectangle())
        .overlay(alignment: .bottom) {
            // A subtle divider that appears more as the header collapses
            Rectangle()
                .fill(.ultraThinMaterial)
                .frame(height: 1 / UIScreen.main.scale)
                .opacity(collapsed ? 1 : 0)
        }
    }
}

// MARK: - Row
private struct RowCard: View {
    let item: MockItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.secondary.opacity(0.15))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: item.icon)
                        .font(.title2)
                        .foregroundStyle(.secondary)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
    }
}

// MARK: - Mock Data
private struct MockItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String

    static let samples: [MockItem] = (1...24).map {
        MockItem(
            title: "List Row \($0)",
            subtitle: "This is a sample row used to demonstrate the sticky and stretchy header behavior.",
            icon: ["doc.text", "bolt.fill", "leaf.fill", "calendar", "flame.fill", "heart.fill"].randomElement()!
        )
    }
}

#Preview {
    StickyHeaderListView()
}
