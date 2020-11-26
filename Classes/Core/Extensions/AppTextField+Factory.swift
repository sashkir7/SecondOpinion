//
//  Created by Continuous Integration on 08.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

extension AppTextField {

    static func make<TextField: AppTextField>(withPlaceholder placeholder: String, configHandler: (TextField) -> Void) -> TextField {
        let textField = TextField()
        textField.backgroundColor = .solitude
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true

        textField.defaultTextAttributes = StringAttributes.textFieldText()
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: StringAttributes.textFieldPlaceholder())
        configHandler(textField)
        return textField
    }
}
