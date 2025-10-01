import shared
import SwiftUI
import GitLabourerUI

public struct ContentView: View {

    @State private var data: [Project] = []

    public init() {}

    public var body: some View {
        if true {
            EmptyView()
        } else {
            EmptyView()
        }
    }

    private func fetchData() {
        Task {
            do {
                data = try await appDependency.projectsUseCase.invoke()
                print("data fetched \(data)")
            } catch {

            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
