//
//  Created by Dmitry Frishbuter on 30.04.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

struct RestoreParameters {
    var password: String
    var token: String
}

// MARK: -  JSONConvertible

extension RestoreParameters: JSONConvertible {

    func asJSONObject() -> [String: Any] {
        return [
            "password": password,
            "token": token
        ]
    }
}
