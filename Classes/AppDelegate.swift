//
//  Created by Dmitry Surkov on 05/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

typealias LaunchOptions = [UIApplication.LaunchOptionsKey: Any]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var appCoordinator: AppCoordinator = .init()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: LaunchOptions?) -> Bool {
        AppConfigurator.configure(application, with: launchOptions)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator.rootViewController
        window?.makeKeyAndVisible()

        appCoordinator.start(launchOptions: launchOptions)

        return true
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return appCoordinator.continueUserActivity(userActivity, restorationHandler: restorationHandler)
    }
}
