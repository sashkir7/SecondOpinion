//
//  Created by Continuous Integration on 16.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Alamofire
import Networking

enum AuthEndpoint {
    case signUp(SignUpParameters)
    case signIn(email: String, password: String)
    case forgotPassword(email: String)
    case restorePassword(RestoreParameters)
}

extension AuthEndpoint: Endpoint {

    var path: String {
        switch self {
        case .signUp:
            return "register"
        case .signIn:
            return "login"
        case .forgotPassword:
            return "auth/forgot-password"
        case .restorePassword:
            return "auth/restore-password"
        }
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: Parameters? {
        switch self {
        case .signUp(let parameters):
            return parameters.asJSONObject()
        case let .signIn(email, password):
            return ["email": email, "password": password]
        case .forgotPassword(let email):
            return ["email": email]
        case .restorePassword(let parameters):
            return parameters.asJSONObject()
        }
    }

    var authorizationType: AuthorizationType {
        return .none
    }

    func error(for statusCode: StatusCode) -> Error? {
        return statusCode.code == 401 ? AuthEndpointError.unauthorized : nil
    }
}
