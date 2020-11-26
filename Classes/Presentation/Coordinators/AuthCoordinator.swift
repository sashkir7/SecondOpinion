//
//  Created by Continuous Integration on 12.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol AuthCoordinatorOutput: CoordinatorOutput {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator)
}

final class AuthCoordinator: Coordinator<NavigationController> {

    enum Context {
        case welcome
        case signIn
    }

    typealias Dependencies = HasSessionService & HasProfileService

    private let dependencies: Dependencies

    private weak var authOutput: AuthCoordinatorOutput?
    override weak var output: CoordinatorOutput? {
        get {
            return authOutput
        }
        set {
            guard let authOutput = newValue as? AuthCoordinatorOutput else {
                fatalError("Incorrect output type")
            }
            self.authOutput = authOutput
        }
    }

    // MARK: -  Lifecycle

    init(rootViewController: NavigationController? = nil, dependencies: Dependencies = ServiceContainer()) {
        let rootViewController = rootViewController ?? NavigationController()
        self.dependencies = dependencies
        super.init(rootViewController: rootViewController)
    }

    func start(animated: Bool, context: Context) {
        rootViewController.setNavigationBarHidden(false, animated: false)

        switch context {
        case .welcome:
            showWelcomeModule(animated: animated)
        case .signIn:
            pushSignInModule(animated: animated)
        }
    }

    private func finish() {
        authOutput?.authCoordinatorDidFinish(self)
    }

    // MARK: -  Private

    private func showWelcomeModule(animated: Bool) {
        let module = WelcomeModule()
        module.output = self
        rootViewController.setViewControllers([module.viewController], animated: animated)
    }

    private func pushSignUpModule(animated: Bool) {
        let module = SignUpModule()
        module.output = self
        rootViewController.pushViewController(module.viewController, animated: true)
    }

    private func pushSignInModule(animated: Bool) {
        let module = LoginModule()
        module.output = self
        rootViewController.pushViewController(module.viewController, animated: animated)
    }

    private func pushResetPasswordModule(animated: Bool) {
        let module = ResetPasswordModule()
        module.output = self
        rootViewController.pushViewController(module.viewController, animated: animated)
    }
}

// MARK: -  WelcomeModuleOutput

extension AuthCoordinator: WelcomeModuleOutput {

    func welcomeModuleDidRequestSignUp(_ moduleInput: WelcomeModuleInput) {
        pushSignUpModule(animated: true)
    }

    func welcomeModuleDidRequestLogIn(_ moduleInput: WelcomeModuleInput) {
        pushSignInModule(animated: true)
    }
}

// MARK: -  SignUpModuleOutput

extension AuthCoordinator: SignUpModuleOutput {

    func signUpModuleDidComplete(_ moduleInput: SignUpModuleInput) {
        finish()
    }

    func signUpModuleDidRequestTermsAndConditions(_ moduleInput: SignUpModuleInput) {}
    func signUpModule(_ moduleInput: SignUpModuleInput, didFailWith error: Error) {
        presentErrorAlert(for: error)
    }
}

// MARK: -  LoginModuleOutput

extension AuthCoordinator: LoginModuleOutput {

    func loginModuleDidRequestResetPassword(_ moduleInput: LoginModuleInput) {
        pushResetPasswordModule(animated: true)
    }

    func loginModuleDidComplete(_ moduleInput: LoginModuleInput) {
        finish()
    }

    func loginModule(_ moduleInput: LoginModuleInput, didFailWith error: Error) {
        presentErrorAlert(for: error)
    }

}

// MARK: -  ResetPasswordModuleOutput

extension AuthCoordinator: ResetPasswordModuleOutput {

    func resetPasswordModule(_ moduleInput: ResetPasswordModuleInput, didCompleteWithEmail email: String) {
        let inboxAction = UIAlertAction(title: L10n.Alert.RecoveryLinkSent.Action.checkInbox, style: .cancel) { _ in
            UIApplication.shared.openMailApp()
        }
        let logInAction = UIAlertAction(title: L10n.Alert.RecoveryLinkSent.Action.logIn, style: .default) { [weak self] _ in
            self?.rootViewController.popViewController(animated: true)
        }
        presentAlert(
            withTitle: L10n.Alert.RecoveryLinkSent.title,
            message: L10n.Alert.RecoveryLinkSent.message(email),
            actions: [inboxAction, logInAction]
        )
    }

    func resetPasswordModule(_ moduleInput: ResetPasswordModuleInput, didFailWith error: Error) {
        presentErrorAlert(for: error)
    }
}
