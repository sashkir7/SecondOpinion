//
//  Created by Dmitry Frishbuter on 09.04.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import UIKit

extension UIApplication {

    func openMailApp() {
        let url = URL(string: "message://")!
        if canOpenURL(url) {
            open(url, options: [:], completionHandler: nil)
        }
    }

    func openAppSettings() {
        let url = URL(string: UIApplication.openSettingsURLString)!
        if canOpenURL(url) {
            open(url, options: [:], completionHandler: nil)
        }
    }

    func openSubscriptionSettings() {
        let url = URL(string: "itms-apps://apps.apple.com/account/subscriptions")!
        if canOpenURL(url) {
            open(url, options: [:], completionHandler: nil)
        }
    }
}
