import SwiftUI

public struct SearchView: View {
    @State private var query: String = ""
    @FocusState private var focused: Bool
    
    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                if query.isEmpty {
                    Section("Suggestions") {
                        ForEach(["Projects", "Merge Requests", "Issues", "Pipelines", "Groups", "Users"], id: \.self) { item in
                            Label(item, systemImage: "magnifyingglass")
                        }
                    }
                } else {
                    Section("Results") {
                        Text("Searching for “\(query)”…")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Search")
        }
        .searchable(
            text: $query,
            placement: .sidebar,
            prompt: "Search"
        )
        .searchFocused($focused)
//        .task {
//            // Ensures the field becomes first responder as soon as the view appears.
////            isSearchFocused = true
//            
//            // If you ever see it not take focus reliably, uncomment the small delay:
//            try? await Task.sleep(nanoseconds: 1_000_000_000)
//            focused = true
//        }
    }
}

//#Preview {
//    SearchView()
//}
