//
//  Created by Alx Krw on 08.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit.UIFont

extension UIFont {

    static func titleFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-SemiBold", size: size)!
    }

    static func appFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Regular", size: size)!
    }

    static func mediumAppFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Poppins-Medium", size: size)!
    }

    static func tabBarTitleFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SFProText-Regular", size: size)!
    }
}
