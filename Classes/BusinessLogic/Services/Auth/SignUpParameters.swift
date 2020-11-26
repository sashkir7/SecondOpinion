//
//  Created by Continuous Integration on 16.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

struct SignUpParameters {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
}

// MARK: -  JSONConvertible

extension SignUpParameters: JSONConvertible {

    func asJSONObject() -> [String: Any] {
        return [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "password": password
        ]
    }
}
