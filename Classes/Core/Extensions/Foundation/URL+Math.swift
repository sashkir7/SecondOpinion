//
//  Created by Dmitry Frishbuter on 05/05/2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import Foundation

extension URL {

    static func + (lhs: URL, rhs: String) -> URL {
        return lhs.appendingPathComponent(rhs)
    }

    static func + (lhs: URL, rhs: URL) -> URL {
        let trimmed = rhs.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return lhs.appendingPathComponent(trimmed)
    }
}
