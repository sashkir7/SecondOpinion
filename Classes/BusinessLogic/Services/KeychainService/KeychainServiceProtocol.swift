//
//  Created by Dmitry Frishbuter on 09/04/2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

protocol HasKeychainService {
    var keychainService: KeychainServiceProtocol { get }
}

protocol KeychainServiceProtocol: class {
    subscript(key: String) -> String? { get set }
}
