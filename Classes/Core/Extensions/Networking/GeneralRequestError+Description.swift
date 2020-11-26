//
//  Created by Alx Krw on 21.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Networking

extension GeneralRequestError {

    public var description: String {
        let typeDescription = String(describing: type(of: self))
        switch self {
        case .noInternetConnection:
            return "\(typeDescription): No internet connection"
        case .timedOut:
            return "\(typeDescription): Request is timed out"
        case .noAuth:
            return "\(typeDescription): \(401) - Request is not authorized"
        case .forbidden:
            return "\(typeDescription): \(403) - Forbidden"
        case .notFound:
            return "\(typeDescription): \(404) - Not found"
        case .cancelled:
            return "\(typeDescription): Request has been cancelled"
        }
    }

}
