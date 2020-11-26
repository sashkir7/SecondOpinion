//
//  Created by Alx Krw on 16.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Foundation

extension Optional where Wrapped: Collection {

    var isNilOrEmpty: Bool {
        switch self {
        case .some(let wrapped):
            return wrapped.isEmpty
        case .none:
            return true
        }
    }
}

extension Optional where Wrapped == NSAttributedString {

    var isNilOrEmpty: Bool {
        switch self {
        case .some(let wrapped):
            return wrapped.string.isEmpty
        case .none:
            return true
        }
    }
}

infix operator ??> : NilCoalescingPrecedence
func ??><T, U> (optional: T?, execute: (T) -> (U)) -> U? {
    guard let value = optional else {
        return nil
    }
    return execute(value)
}
