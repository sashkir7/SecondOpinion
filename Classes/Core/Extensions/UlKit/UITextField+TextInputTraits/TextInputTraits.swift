//
//  Created by Dmitry Frishbuter on 18.10.2018
//  Copyright © 2018 Ronas IT. All rights reserved.
//

import UIKit.UITextInputTraits

final class TextInputTraits: NSObject, UITextInputTraits {

    enum Pattern {
        case none
        case username
        case name
        case phone
        case email
        case password
        case currency
        case integer
        case plainText
        case postcode

        var keyboardType: UIKeyboardType {
            switch self {
            case .name:
                return .default
            case .phone:
                return .phonePad
            case .email:
                return .emailAddress
            case .currency:
                return .decimalPad
            case .integer:
                return .numberPad
            case .postcode:
                return .numbersAndPunctuation
            default:
                return .default
            }
        }

        var autocorrectionType: UITextAutocorrectionType {
            switch self {
            case .name, .username, .phone, .email, .password, .currency, .integer:
                return .no
            case .plainText:
                return .yes
            default:
                return .default
            }
        }

        var autocapitalizationType: UITextAutocapitalizationType {
            switch self {
            case .name:
                return .words
            case .username, .phone, .email, .password, .currency, .integer:
                return .none
            default:
                return .sentences
            }
        }

        var spellCheckingType: UITextSpellCheckingType {
            switch self {
            case .name, .username, .phone, .email, .password, .currency, .integer:
                return .no
            case .plainText:
                return .yes
            default:
                return .default
            }
        }
    }

    var pattern: TextInputTraits.Pattern
    var keyboardType: UIKeyboardType
    var keyboardAppearance: UIKeyboardAppearance
    var autocorrectionType: UITextAutocorrectionType
    var autocapitalizationType: UITextAutocapitalizationType
    var spellCheckingType: UITextSpellCheckingType
    var returnKeyType: UIReturnKeyType
    var enablesReturnKeyAutomatically: Bool

    private var _isSecureTextEntry: Bool
    var isSecureTextEntry: Bool {
        @objc(isSecureTextEntry) get {
            return _isSecureTextEntry
        }
        @objc(setSecureTextEntry:) set {
            _isSecureTextEntry = newValue
        }
    }

    init(pattern: TextInputTraits.Pattern) {
        self.pattern = pattern

        keyboardType = pattern.keyboardType
        autocorrectionType = pattern.autocorrectionType
        autocapitalizationType = pattern.autocapitalizationType
        spellCheckingType = pattern.spellCheckingType
        keyboardAppearance = .default
        returnKeyType = .done
        enablesReturnKeyAutomatically = false
        _isSecureTextEntry = pattern == .password

        super.init()
    }
}
