//
//  Created by Alx Krw on 23.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

extension AppTextView {

    static func make<TextView: AppTextView>(withPlaceholder placeholder: String, configHandler: (TextView) -> Void) -> TextView {
        let textView = TextView()
        textView.backgroundColor = .solitude
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 17, bottom: 20, right: 17)
        textView.layer.masksToBounds = true
        textView.textAlignment = .left
        textView.isScrollEnabled = true
        textView.attributedText = NSAttributedString(
            string: placeholder,
            attributes: StringAttributes.textFieldPlaceholder()
        )
        configHandler(textView)
        return textView
    }
}
