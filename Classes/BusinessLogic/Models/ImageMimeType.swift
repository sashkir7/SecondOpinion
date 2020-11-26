//
//  Created by Dmitry Frishbuter on 01.05.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

public enum ImageMimeType: String {
    case jpeg = "image/jpeg"
    case png = "image/png"

    var fileExtension: String {
        switch self {
        case .jpeg:
            return "jpeg"
        case .png:
            return "png"
        }
    }
}
