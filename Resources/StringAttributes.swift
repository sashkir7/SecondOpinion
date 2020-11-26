//
//  Created by Continuous Integration on 14.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

enum StringAttributes {

    static func textFieldText() -> [NSAttributedString.Key: Any] {
        return [
            .font: UIFont.appFont(ofSize: 17),
            .foregroundColor: UIColor.cyprus
        ]
    }

    static func textFieldPlaceholder() -> [NSAttributedString.Key: Any] {
        return [
            .font: UIFont.appFont(ofSize: 17),
            .foregroundColor: UIColor.manatee
        ]
    }

    static func textFieldTitle() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 20

        return [
            .font: UIFont.mediumAppFont(ofSize: 15),
            .foregroundColor: UIColor.cyprus,
            .paragraphStyle: paragraphStyle
        ]
    }

    static func largeTitle() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 41
        paragraphStyle.lineBreakMode = .byWordWrapping

        return [
            .font: UIFont.titleFont(ofSize: 34),
            .foregroundColor: UIColor.cyprus,
            .paragraphStyle: paragraphStyle
        ]
    }

    static func agreementTitle() -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 16
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping

        return [
            .font: UIFont.appFont(ofSize: 12),
            .foregroundColor: UIColor.manatee,
            .paragraphStyle: paragraphStyle
        ]
    }
}
