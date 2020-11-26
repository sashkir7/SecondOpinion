//
//  Created by Dmitry Surkov on 05/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseCrashlytics

final class AppConfigurator {

    static func configure(_ application: UIApplication, with launchOptions: LaunchOptions?) {
        let appVersion = "\(Bundle.main.appVersion) (\(Bundle.main.bundleVersion))"
        UserDefaults.standard.appVersion = appVersion
        FirebaseApp.configure()

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont.tabBarTitleFont(ofSize: 12)], for: .normal)
    }
}

private extension UserDefaults {

    var appVersion: String? {
        get {
            return string(forKey: #function)
        }
        set {
            set(newValue, forKey: #function)
        }
    }
}
