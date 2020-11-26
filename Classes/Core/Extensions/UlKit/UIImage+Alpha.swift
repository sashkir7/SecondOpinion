//
//  Created by Dmitry Frishbuter on 02/10/2018
//  Copyright © 2019 98 Training Pty Limited. All rights reserved.
//

import UIKit.UIImage

extension UIImage {

    var isOpaque: Bool {
        return !containsAlphaComponent
    }

    var containsAlphaComponent: Bool {
        let alphaInfo = cgImage?.alphaInfo

        return alphaInfo == .first ||
               alphaInfo == .last ||
               alphaInfo == .premultipliedFirst ||
               alphaInfo == .premultipliedLast
    }

    func with(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
