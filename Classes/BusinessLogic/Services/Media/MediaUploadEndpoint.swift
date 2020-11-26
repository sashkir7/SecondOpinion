//
//  Created by Dmitry Frishbuter on 01.05.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import Foundation
import Alamofire
import Networking

enum MediaUploadEndpoint {
    case uploadImage(Data)
}

extension MediaUploadEndpoint: UploadEndpoint {

    var requiresAuthorization: Bool {
        return true
    }

    var path: String {
        return "media"
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: Parameters? {
        return nil
    }

    var imageBodyParts: [ImageBodyPart] {
        switch self {
        case .uploadImage(let data):
            return [.init(imageData: data, name: "file", mimeType: ImageMimeType.jpeg.rawValue)]
        }
    }

    var authorizationType: AuthorizationType {
        return .bearer
    }
}
