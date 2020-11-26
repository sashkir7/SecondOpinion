//
//  Created by Alx Krw on 24.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

extension String {

    func widthWith(font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: fontAttributes)
        return size.width
    }

    func heightWith(font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: fontAttributes)
        return size.height
    }
}
