//
//  Created by Alx Krw on 27.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Alamofire
import Networking

enum ConsultationEndpoint {
    case createConsultation(CreatedConsultationParameters)
}

extension ConsultationEndpoint: Endpoint {

    var path: String {
        switch self {
        case .createConsultation:
            return "consultations"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createConsultation:
            return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .createConsultation(let parameters):
            return parameters.asJSONObject()
        }
    }

    var authorizationType: AuthorizationType {
        return .bearer
    }
}
