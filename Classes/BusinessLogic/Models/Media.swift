//
//  Created by Dmitry Frishbuter on 01.05.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import Foundation
import CoreGraphics

struct Media: Codable, Equatable, Identifiable {

    typealias ID = UInt

    private enum CodingKeys: String, CodingKey {
        case id
        case url = "link"
        case name
        case ownerID = "owner_id"
    }

    enum Constants {
        static let profilePhotoMaxDimension: CGFloat = 336
    }

    let id: ID
    let url: URL
    let name: String?
    let ownerID: UInt?

    var absoluteURL: URL {
        return AppConfiguration.serverURL + url
    }
}
