//
//  Created by Alx Krw on 14.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Foundation

extension String {

    var isValidName: Bool {
        return matches("^[.a-zA-Z:-]{1,100}$")
    }

    var isValidEmail: Bool {
        return matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
    }

    var isValidPassword: Bool {
        return self.count > 4
    }

    func matches(_ regex: String) -> Bool {
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
