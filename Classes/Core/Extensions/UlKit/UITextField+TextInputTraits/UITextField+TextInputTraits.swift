//
//  Created by Dmitry Frishbuter on 29.08.2019
//  Copyright © 2019 Ronas IT. All rights reserved.
//

import UIKit

extension UITextField {

    convenience init(inputTraitsPattern: TextInputTraits.Pattern, returnKeyType: UIReturnKeyType? = nil) {
        self.init(frame: .zero)
        let inputTraits = TextInputTraits(pattern: inputTraitsPattern)
        if let returnKeyType = returnKeyType {
            inputTraits.returnKeyType = returnKeyType
        }
        self.setTextInputTraits(inputTraits)
    }

    func setTextInputTraits(_ textInputTraits: TextInputTraits) {
        keyboardType = textInputTraits.keyboardType
        autocorrectionType = textInputTraits.autocorrectionType
        autocapitalizationType = textInputTraits.autocapitalizationType
        spellCheckingType = textInputTraits.spellCheckingType
        isSecureTextEntry = textInputTraits.isSecureTextEntry
        keyboardAppearance = textInputTraits.keyboardAppearance
        returnKeyType = textInputTraits.returnKeyType
        enablesReturnKeyAutomatically = textInputTraits.enablesReturnKeyAutomatically
    }

    func setTextInputTraits(with pattern: TextInputTraits.Pattern) {
        let traits = TextInputTraits(pattern: pattern)
        setTextInputTraits(traits)
    }
}
