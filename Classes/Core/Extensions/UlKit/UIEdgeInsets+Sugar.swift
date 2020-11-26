//
//  Created by Nikita Zatsepilov on 29/08/2019
//  Copyright © 2019 98 Training Pty Limited. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    var topAndBottom: CGFloat {
        return top + bottom
    }

    var leftAndRight: CGFloat {
        return left + right
    }

    init(margin: CGFloat) {
        self.init(top: margin, left: margin, bottom: margin, right: margin)
    }

    init(verticalMargin: CGFloat, horizontalMargin: CGFloat) {
        self.init(top: verticalMargin, left: horizontalMargin, bottom: verticalMargin, right: horizontalMargin)
    }

    static func top(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: 0, bottom: 0, right: 0)
    }

    static func left(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 0)
    }

    static func bottom(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
    }

    static func right(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inset)
    }

    static func leftAndRight(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }

    static func + (insets: UIEdgeInsets, additionalInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: insets.top + additionalInsets.top,
            left: insets.left + additionalInsets.left,
            bottom: insets.bottom + additionalInsets.bottom,
            right: insets.right + additionalInsets.right
        )
    }

    static func - (insets: UIEdgeInsets, additionalInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: insets.top - additionalInsets.top,
            left: insets.left - additionalInsets.left,
            bottom: insets.bottom - additionalInsets.bottom,
            right: insets.right - additionalInsets.right
        )
    }

    // swiftlint:disable shorthand_operator

    static func -= (insets: inout UIEdgeInsets, additionalInsets: UIEdgeInsets) {
        insets = insets - additionalInsets
    }

    static func += (insets: inout UIEdgeInsets, additionalInsets: UIEdgeInsets) {
        insets = insets + additionalInsets
    }

    // swiftlint:enable shorthand_operator
}
