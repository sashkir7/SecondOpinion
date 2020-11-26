//
//  Created by Alx Krw on 16.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

final class NavigationBarAppearance {
    var isHidden: Bool
    var tintColor: UIColor
    var barTintColor: UIColor?
    var backgroundColor: UIColor
    var backgroundImage: UIImage?
    var shadowImage: UIImage?
    var isTranslucent: Bool

    init(isHidden: Bool,
         tintColor: UIColor = .black,
         barTintColor: UIColor? = .clear,
         backgroundColor: UIColor = .clear,
         backgroundImage: UIImage? = UIImage(),
         shadowImage: UIImage? = UIImage(),
         isTranslucent: Bool = true) {
        self.isHidden = isHidden
        self.tintColor = tintColor
        self.barTintColor = barTintColor
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
        self.shadowImage = shadowImage
        self.isTranslucent = isTranslucent
    }
}

extension NavigationBarAppearance {

    static func initial() -> NavigationBarAppearance {
        return NavigationBarAppearance(
            isHidden: false,
            tintColor: .manatee
        )
    }

}

protocol NavigationBarAppearanceContainer: class {
    var navigationBarAppearance: NavigationBarAppearance { get }
}
