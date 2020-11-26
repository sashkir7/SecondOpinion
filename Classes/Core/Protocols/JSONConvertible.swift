//
//  Created by Continuous Integration on 16.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Foundation

protocol JSONConvertible {
    func asJSONObject() -> [String: Any]
}
