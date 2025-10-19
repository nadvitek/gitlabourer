import Foundation
import shared
import Observation
import Core

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
    private weak var flowDelegate: LoginFlowDelegate?

    // MARK: - Initializers

    public init(
        dependencies: LoginViewModelDependencies,
        flowDelegate: LoginFlowDelegate?
    ) {
        self.dependencies = dependencies
        self.flowDelegate = flowDelegate
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
                    UserDefaults.standard.isLoggedIn = true

                    flowDelegate?.logIn()
                } else {
                    errorMessage = "Invalid Personal Access Token"
                }
            } catch {
                errorMessage = error.localizedDescription.description
            }
        }
    }
}
