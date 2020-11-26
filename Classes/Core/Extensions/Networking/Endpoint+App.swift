//
//  Created by Nikita Zatsepilov on 31.10.2019
//  Copyright © 2019 98 Training Pty Limited. All rights reserved.
//

import Foundation
import Networking
import Alamofire

public typealias HTTPHeaders = Alamofire.HTTPHeaders
public typealias RequestHeaders = Networking.RequestHeaders
public typealias RequestHeader = Networking.RequestHeader

extension Endpoint {

    var baseURL: URL {
        return AppConfiguration.serverURL
    }

    var headers: [RequestHeader] {
        return [
            RequestHeaders.accept("application/json"),
            RequestHeaders.contentType("application/json")
        ]
    }

    var parameterEncoding: ParameterEncoding {
        switch method {
        case .get:
            return CustomURLEncoding()
        default:
            return JSONEncoding.default
        }
    }

    var parameters: Parameters? {
        nil
    }
}

struct CustomURLEncoding: ParameterEncoding {

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        request.url = URL(string: request.url!.absoluteString.replacingOccurrences(of: "%5B%5D%5B%5D=", with: "[]="))
        return request
    }
}
