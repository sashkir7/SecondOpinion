//
//  Created by Dmitry Frishbuter on 12/06/2019
//  Copyright © 2019 98 Training Pty Limited. All rights reserved.
//

import UIKit

extension UIImage {

    func resized(to size: CGSize) -> UIImage? {
        guard size != .zero else {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0.0)
        draw(in: CGRect(origin: .zero, size: size))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage
    }

    func resized(withMaxDimension maxDimension: CGFloat) -> UIImage? {
        let imageMaxDimension = max(size.width, size.height)
        if imageMaxDimension < maxDimension {
            return self
        }
        let aspectRatio = size.width / size.height
        let imageSize: CGSize
        if aspectRatio > 1 {
            imageSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            imageSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }
        return resized(to: imageSize)
    }

    func resized(withMinDimension minDimension: CGFloat) -> UIImage? {
        let imageMinDimension = min(size.width, size.height)
        if imageMinDimension < minDimension {
            return self
        }
        let aspectRatio = size.width / size.height
        let imageSize: CGSize
        if aspectRatio > 1 {
            imageSize = CGSize(width: minDimension * aspectRatio, height: minDimension)
        } else {
            imageSize = CGSize(width: minDimension, height: minDimension / aspectRatio)
        }
        return resized(to: imageSize)
    }
}
