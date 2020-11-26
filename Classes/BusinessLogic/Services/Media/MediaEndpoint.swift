//
//  Created by Dmitry Frishbuter on 01.05.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import Alamofire
import Networking

enum MediaEndpoint {
    case fetchMedia(Media.ID)
    case deleteMedia(Media.ID)
}

extension MediaEndpoint: Endpoint {

    var path: String {
        switch self {
        case .fetchMedia(let id), .deleteMedia(let id):
            return "media/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchMedia:
            return .get
        case .deleteMedia:
            return .delete
        }
    }

    var parameters: Parameters? {
        return nil
    }

    var requiresAuthorization: Bool {
        return true
    }

    var authorizationType: AuthorizationType {
        return .bearer
    }
}
