//
//  Created by Dmitry Frishbuter on 01.05.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import Networking
import RxSwift
import UIKit.UIImage

protocol HasMediaService {
    var mediaService: MediaServiceProtocol { get }
}

protocol MediaServiceProtocol: class {
    func uploadImageObservable(_ image: UIImage, maxDimension: CGFloat?, mimeType: ImageMimeType) -> Observable<Media>
    func deleteImageObservable(with id: Media.ID) -> Observable<Void>
}

extension MediaServiceProtocol {

    func uploadImageObservable(_ image: UIImage, mimeType: ImageMimeType) -> Observable<Media> {
        uploadImageObservable(image, maxDimension: nil, mimeType: mimeType)
    }
}
