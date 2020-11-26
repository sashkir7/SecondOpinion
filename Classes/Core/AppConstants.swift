//
//  Created by Alx Krw on 13.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import CoreGraphics
import UIKit

enum AppConstants {
    static let referenceScreenSize: CGSize = CGSize(width: 375, height: 812)
}

extension Numeric where Self: BinaryInteger {

    var widthWithRatio: CGFloat {
        let width = UIScreen.main.bounds.width

        var widthWithRound = CGFloat(self) / AppConstants.referenceScreenSize.width * width
        widthWithRound.round()

        return widthWithRound
    }

    var heightWithRatio: CGFloat {
        let height = UIScreen.main.bounds.height
        var heightWithRound = CGFloat(self) / AppConstants.referenceScreenSize.height * height
        heightWithRound.round()

        return heightWithRound
    }
}
