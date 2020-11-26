//
//  Created by Continuous Integration on 08.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

class AppTextField: UITextField {

    var insetX: CGFloat = 20

    private var _backgroundColor: UIColor?
    override var backgroundColor: UIColor? {
        didSet {
            if _backgroundColor == nil {
                _backgroundColor = backgroundColor
            }
        }
    }

    override var text: String? {
        get {
            return super.text
        }
        set {
            if super.text != newValue {
                super.text = newValue
            }
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        tintColor = .eveningSea
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: 0)
    }

    override func becomeFirstResponder() -> Bool {
        let isFirstResponder = super.becomeFirstResponder()
        if isFirstResponder {
            backgroundColor = _backgroundColor
        }
        return isFirstResponder
    }

    override func resignFirstResponder() -> Bool {
        let isResigned = super.resignFirstResponder()
        if isResigned {
            backgroundColor = _backgroundColor
        }
        return isResigned
    }
}
