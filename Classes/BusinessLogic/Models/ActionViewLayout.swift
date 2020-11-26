//
//  Created by Alx Krw on 23.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

struct ActionViewLayout {
    let topInset: CGFloat = 38.heightWithRatio
    let heiht: CGFloat = 52
    let bottomInset: CGFloat = 38.heightWithRatio
    let leftInset: CGFloat = 20.widthWithRatio
    let width: CGFloat? = nil
    let rightInset: CGFloat = 20.widthWithRatio

    var heightWithInsets: CGFloat {
        return topInset + heiht + bottomInset
    }
}
