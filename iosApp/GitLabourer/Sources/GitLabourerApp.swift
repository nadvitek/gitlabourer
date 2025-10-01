import shared
import SwiftUI

@main
struct GitLabourerApp: App {
    init() {
        KoinKt.doInitKoin(extraModules: [])
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
