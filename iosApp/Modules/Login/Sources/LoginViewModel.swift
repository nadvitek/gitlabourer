import Foundation
import shared
import Observation

// MARK: - LoginViewModel

public protocol LoginViewModel {
    var isLoading: Bool { get }
    var token: String { get set }
    var errorMessage: String { get set }

    func login()
}

// MARK: - LoginViewModelImpl

@Observable
public class LoginViewModelImpl: LoginViewModel {

    // MARK: - Internal properties

    public var isLoading: Bool = false
    public var token: String = ""
    public var errorMessage: String = ""

    // MARK: - Private properties

    private let dependencies: LoginViewModelDependencies

    // MARK: - Initializers

    public init(dependencies: LoginViewModelDependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Internal interface

    public func login() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            isLoading = true
            defer { isLoading = false }

            do {
                let user = try await dependencies.loginUseCase.invoke(
                    token: token
                )

                if user != nil {
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                } else {
                    errorMessage = ""
                }
            } catch {
                print(error)
                errorMessage = ""
            }
        }
    }
}
