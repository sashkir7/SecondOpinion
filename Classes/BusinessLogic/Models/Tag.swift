//
//  Created by Alx Krw on 25.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Foundation

struct Tag: Codable, Equatable, Identifiable {
    typealias ID = UInt
    let id: ID
    let name: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(.id)
        name = try container.decode(.name)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
