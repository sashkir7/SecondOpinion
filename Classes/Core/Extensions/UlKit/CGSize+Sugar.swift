//
//  Created by Dmitry Frishbuter on 11.04.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import UIKit

extension CGSize {

    static var greatest: CGSize {
        let greatestValue: CGFloat = .greatestFiniteMagnitude
        return .init(width: greatestValue, height: greatestValue)
    }

    func inset(by insets: UIEdgeInsets) -> CGSize {
        return CGSize(width: width - insets.leftAndRight, height: height - insets.topAndBottom)
    }

    static func - (size: CGSize, insets: UIEdgeInsets) -> CGSize {
        var size = size
        size.height -= insets.topAndBottom
        size.width -= insets.leftAndRight
        return size
    }

    static func + (size: CGSize, insets: UIEdgeInsets) -> CGSize {
        var size = size
        size.height += insets.topAndBottom
        size.width += insets.leftAndRight
        return size
    }
}
