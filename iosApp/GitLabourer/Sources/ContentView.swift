import shared
import SwiftUI
import GitLabourerUI
import Projects
import Search

public struct ContentView: View {

    // MARK: - Tabs

    private enum TabType: Hashable {
        case projects
        case pipelines
        case jobs
        case settings
        case search
    }

    // MARK: - State

    @State private var selectedTab: TabType = .projects
    
    // MARK: - Initializers

    public init() {
        setupAppearance()
    }
    
    // MARK: - UI

    public var body: some View {
        TabView(selection: $selectedTab) {
            Tab(
                "Projects",
                systemImage: "list.bullet.rectangle",
                value: TabType.projects
            ) {
                NavigationStack {
                    ProjectsView(
                        viewModel: ProjectsViewModelImpl(
                            dependencies: appDependency.projectsViewModelDependencies
                        )
                    )
                }
            }

            Tab(
                "MRs",
                systemImage: "point.topleft.filled.down.to.point.bottomright.curvepath",
                value: TabType.pipelines
            ) {
                NavigationStack {
                    PlaceholderView(title: "Tab 2")
                }
            }

            Tab(
                "Pipelines",
                systemImage: "checklist",
                value: TabType.pipelines
            ) {
                NavigationStack {
                    PlaceholderView(title: "Tab 3")
                }
            }

            Tab(
                "Settings",
                systemImage: "gearshape",
                value: TabType.settings
            ) {
                NavigationStack {
                    PlaceholderView(title: "Settings")
                }
            }

            Tab(
                "Search",
                systemImage: "magnifyingglass",
                value: TabType.search,
                role: .search
            ) {
                SearchView()
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Placeholder View

    private struct PlaceholderView: View {
        let title: String

        var body: some View {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                Text(title)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#if DEBUG

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#endif
