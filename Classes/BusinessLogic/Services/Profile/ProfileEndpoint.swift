//
//  Created by Dmitry Frishbuter on 07.04.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import Networking
import Alamofire

enum ProfileEndpoint {
    case fetchProfile
    case updateProfile(User)
}

extension ProfileEndpoint: Endpoint {

    var path: String {
        return "profile"
    }

    var method: HTTPMethod {
        switch self {
        case .fetchProfile:
            return .get
        case .updateProfile:
            return .put
        }
    }

    var parameters: Parameters? {
        switch self {
        case .updateProfile(let user):
            return user.asJSONObject()
        default:
            return nil
        }
    }

    var requiresAuthorization: Bool {
        return true
    }

    var authorizationType: AuthorizationType {
        return .bearer
    }
}
