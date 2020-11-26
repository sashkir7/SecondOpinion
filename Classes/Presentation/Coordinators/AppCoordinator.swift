//
//  Created by Dmitry Surkov on 05/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator<NavigationController> {

    typealias Dependencies = HasSessionService & HasProfileService

    private let dependencies: Dependencies

    // MARK: - Lifecycle

    init(rootViewController: NavigationController? = nil, dependencies: Dependencies = ServiceContainer()) {
        let rootViewController = rootViewController ?? NavigationController()
        self.dependencies = dependencies
        super.init(rootViewController: rootViewController)
    }

    func start(launchOptions: LaunchOptions?) {
        if dependencies.sessionService.isAuthorized {
            showSplashModule(animated: false)
        } else {
            startAuthCoordinator(animated: false, context: .welcome)
        }
    }

    @discardableResult
    func continueUserActivity(_ userActivity: NSUserActivity, restorationHandler: ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            guard let url = userActivity.webpageURL else {
                return true
            }
            let token = url.lastPathComponent
            let module = PasswordCreationModule(state: .init(token: token))
            module.output = self
            rootViewController.pushViewController(module.viewController, animated: false)
        }
        return true
    }

    private func showSplashModule(animated: Bool) {
        let module = SplashModule()
        module.output = self
        rootViewController.setViewControllers([module.viewController], animated: animated)
    }

    private func startAuthCoordinator(animated: Bool, context: AuthCoordinator.Context) {
        let coordinator = AuthCoordinator(rootViewController: rootViewController)
        coordinator.output = self
        coordinator.start(animated: animated, context: context)
        append(childCoordinator: coordinator)
    }

    private func startMainCoordinator(animated: Bool) {
        let coordinator = MainCoordinator(rootViewController: TabBarController())
        coordinator.output = self
        coordinator.start(from: rootViewController, animated: animated)
        append(childCoordinator: coordinator)
    }
}

// MARK: -  SplashModuleOutput

extension AppCoordinator: SplashModuleOutput {

    func splashModuleDidFail(_ moduleInput: SplashModuleInput) {
        startAuthCoordinator(animated: false, context: .welcome)
    }

    func splashModuleDidValidateSession(_ moduleInput: SplashModuleInput) {
        startMainCoordinator(animated: false)
    }
}

// MARK: -  AuthCoordinatorOutput

extension AppCoordinator: AuthCoordinatorOutput {

    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator) {
        childCoordinatorDidClose(coordinator)
        startMainCoordinator(animated: true)
    }
}

// MARK: -  PasswordCreationModuleOutput

extension AppCoordinator: PasswordCreationModuleOutput {

    func passwordCreationModuleDidComplete(_ moduleInput: PasswordCreationModuleInput) {
        let continueAction = UIAlertAction(title: L10n.Alert.RestorePasswordSuccess.Action.continue, style: .default) { [weak self] _ in
            if let viewController = self?.rootViewController.children.last(where: { $0.isKind(of: LoginViewController.self) }) {
                self?.rootViewController.popToViewController(viewController, animated: true)
            }
        }

        presentAlert(
            withTitle: L10n.Alert.RestorePasswordSuccess.title,
            message: L10n.Alert.RestorePasswordSuccess.message,
            actions: [continueAction]
        )
    }

    func passwordCreationModule(_ moduleInput: PasswordCreationModuleInput, didFailWith error: Error) {
        presentErrorAlert(for: error)
    }
}

// MARK: -  MainCoordinatorOutput

extension AppCoordinator: MainCoordinatorOutput {}
