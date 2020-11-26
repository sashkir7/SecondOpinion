//
//  Created by Dmitry Frishbuter on 09/04/2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import KeychainSwift

final class KeychainService: KeychainServiceProtocol {
    let keychain: KeychainSwift = KeychainSwift(keyPrefix: "SecOP")

    subscript(key: String) -> String? {
        get {
            return keychain.get(key)
        }
        set {
            if let value = newValue {
                keychain.set(value, forKey: key)
            } else {
                keychain.delete(key)
            }
        }
    }
}
