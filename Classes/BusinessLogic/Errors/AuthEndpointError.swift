//
//  Created by Alx Krw on 21.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Foundation

enum AuthEndpointError: LocalizedError {
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return L10n.Error.authorizationFailed
        }
    }
}
