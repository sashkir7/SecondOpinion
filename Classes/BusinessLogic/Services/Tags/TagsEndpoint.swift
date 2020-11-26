//
//  Created by Alx Krw on 25.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Alamofire
import Networking

enum TagsEndpoint {
    case fetchTags
}

extension TagsEndpoint: Endpoint {

    var path: String {
        switch self {
        case .fetchTags:
            return "tags"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchTags:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .fetchTags:
            return nil
        }
    }

    var authorizationType: AuthorizationType {
        return .bearer
    }
}
