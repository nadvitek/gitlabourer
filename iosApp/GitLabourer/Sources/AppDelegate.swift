import shared
import SwiftUI
import Login

@main
struct GitLabourerApp: App {

    @AppStorage("loggedIn") private var loggedIn: Bool = false

    init() {
        KoinKt.doInitKoin(extraModules: [])
    }

    var body: some Scene {
        WindowGroup {
            if loggedIn {
                ContentView()
            } else {
                LoginView(
                    viewModel: LoginViewModelImpl(
                        dependencies: appDependency.loginViewModelDependencies
                    )
                )
            }
        }
    }
}
