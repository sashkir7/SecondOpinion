//
//  Created by Dmitry Frishbuter on 01.05.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import UIKit

extension UIViewController {

    var topmostViewController: UIViewController {
        if let navigationController = self as? UINavigationController,
           let topViewController = navigationController.topViewController {
            return topViewController.topmostViewController
        }

        if let tabBarController = self as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return selectedViewController.topmostViewController
        }

        if let presentedViewController = presentedViewController, !presentedViewController.isBeingDismissed {
            return presentedViewController.topmostViewController
        }

        return self
    }
}
