//
//  Created by Alx Krw on 21.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.barTintColor = .white
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.isTranslucent = true

        tabBar.tintColor = .cyprus
        tabBar.unselectedItemTintColor = .manatee
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
