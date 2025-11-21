import Foundation
import shared
import Observation
import Core

// MARK: - LoginViewModel

public protocol LoginViewModel {
    var isLoading: Bool { get }
    var url: String { get set }
    var token: String { get set }
    var errorMessage: String { get set }
    var isOnboardingPresented: Bool { get set }

    func login()
    func presentOnboarding()
}

// MARK: - LoginViewModelImpl

@Observable
public class LoginViewModelImpl: LoginViewModel {

    // MARK: - Internal properties

    public var isLoading: Bool = false
    public var url: String = ""
    public var token: String = ""
    public var errorMessage: String = ""
    public var isOnboardingPresented: Bool = false

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

    public func presentOnboarding() {
        guard !UserDefaults.standard.wasOnboarded else { return }

        isOnboardingPresented = true
    }

    public func login() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            isLoading = true
            defer { isLoading = false }

            do {
                let user = try await dependencies.loginUseCase.invoke(
                    url: url,
                    token: token
                )

                if let user {
                    UserDefaults.standard.isLoggedIn = true

                    flowDelegate?.logIn(user: user)
                } else {
                    errorMessage = "Invalid Personal Access Token"
                }
            } catch {
                errorMessage = error.localizedDescription.description
            }
        }
    }
}
