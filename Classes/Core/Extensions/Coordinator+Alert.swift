//
//  Created by Dmitry Frishbuter on 01.05.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import UIKit

extension Coordinator {

    func presentErrorAlert(for error: Error, handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: L10n.ok, style: .default, handler: handler)
        if let error = error as? LocalizedError {
            presentAlert(
                withTitle: error.failureReason ?? L10n.Error.unknown,
                message: error.errorDescription,
                actions: [action]
            )
        } else {
            presentAlert(
                withTitle: L10n.Error.unknown,
                message: L10n.Error.serverError,
                actions: [action]
            )
        }
    }

    func presentAlert(withTitle title: String = Bundle.main.appName, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: L10n.ok, style: .default, handler: handler)
        presentAlert(withTitle: title, message: message, actions: [action])
    }

    func presentAlert(withTitle title: String? = Bundle.main.appName,
                      message: String? = nil,
                      style: UIAlertController.Style = .alert,
                      actions: [UIAlertAction],
                      tintColor: UIColor = .black,
                      animated: Bool = true,
                      completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.overrideUserInterfaceStyle = .light
        alertController.view.tintColor = tintColor
        actions.forEach(alertController.addAction)
        rootViewController.topmostViewController.present(
            alertController,
            animated: animated,
            completion: completion
        )
    }
}
