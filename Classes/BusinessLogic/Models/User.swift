//
//  Created by Continuous Integration on 16.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Foundation

struct User: Codable, Equatable, Identifiable {
    typealias ID = UInt

    let id: ID
    var firstName: String
    var lastName: String
    var email: String

    var fullName: String {
        return firstName + " " + lastName
    }

    var password: String = ""

    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(.id)
        firstName = try container.decode(.firstName)
        lastName = try container.decode(.lastName)
        email = try container.decode(.email)
    }
}

// MARK: -  JSONConvertible

extension User: JSONConvertible {

    func asJSONObject() -> [String: Any] {
        var jsonObject: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email
        ]

        if !password.isEmpty {
            jsonObject["password"] = password
        }

        return jsonObject
    }
}
