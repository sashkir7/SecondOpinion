//
//  Created by Dmitry Frishbuter on 08/04/2020
//  Copyright © 2018 98 Training Pty Limited. All rights reserved.
//

import Foundation

extension DecodingError {

    static var dataCorrupted: DecodingError {
        return .dataCorrupted(Context(codingPath: [], debugDescription: "Data corrupted"))
    }

    static func dateCorruptedError<C>(forKey key: C.Key, in container: C) -> DecodingError where C: KeyedDecodingContainerProtocol {
        return .dataCorruptedError(forKey: key, in: container, debugDescription: "Date string does not match format expected by formatter.")
    }

    static func dataCorruptedError<C>(forType type: Any.Type, key: C.Key, in container: C) -> DecodingError where C: KeyedDecodingContainerProtocol {
        return .dataCorruptedError(forKey: key, in: container, debugDescription: "Unable to map data for type \(String(describing: type)) key \(key)")
    }
}
