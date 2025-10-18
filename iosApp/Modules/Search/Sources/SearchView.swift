import SwiftUI

public struct SearchView: View {
    @State private var query: String = ""
    @State private var isPresented: Bool = true
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
            isPresented: $isPresented,
            placement: .toolbarPrincipal,
            prompt: "Search"
        )
        .focusable(true)
        .searchFocused($focused)
        .onAppear {
            isPresented = true
        }
    }
}

//#Preview {
//    SearchView()
//}
