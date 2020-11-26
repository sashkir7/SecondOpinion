//
//  Created by Alx Krw on 07.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(r red: Int, g green: Int, b blue: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: alpha)
    }
}
