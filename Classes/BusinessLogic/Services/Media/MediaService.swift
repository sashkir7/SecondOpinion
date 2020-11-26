//
//  Created by Dmitry Frishbuter on 01.05.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import Foundation.NSData
import Networking
import RxSwift
import UIKit.UIImage

final class MediaService: NetworkService, MediaServiceProtocol {

    private let sessionService: SessionServiceProtocol

    private enum Error: LocalizedError {
        case invalidImage

        var errorDescription: String? {
            switch self {
            case .invalidImage:
                return L10n.Error.invalidImage
            }
        }
    }

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    init(sessionService: SessionServiceProtocol,
         requestAdaptingService: RequestAdaptingServiceProtocol,
         errorHandlingService: ErrorHandlingServiceProtocol) {
        self.sessionService = sessionService
        super.init(requestAdaptingService: requestAdaptingService, errorHandlingService: errorHandlingService)
    }

    func uploadImageObservable(_ image: UIImage, maxDimension: CGFloat?, mimeType: ImageMimeType) -> Observable<Media> {
        imageDataObservable(for: image, maxDimension: maxDimension, mimeType: mimeType)
            .flatMap(weak: self) { strongSelf, imageData -> Observable<Media> in
                let endpoint = MediaUploadEndpoint.uploadImage(imageData)
                return strongSelf.rx.uploadRequest(endpoint: endpoint, decoder: strongSelf.decoder)
            }
    }

    func deleteImageObservable(with id: Media.ID) -> Observable<Void> {
        return rx.nonCancellableRequest(endpoint: MediaEndpoint.deleteMedia(id))
    }

    // MARK: -  Private

    private func imageDataObservable(for image: UIImage, maxDimension: CGFloat?, mimeType: ImageMimeType) -> Observable<Data> {
        Observable.just(image)
            .flatMap { image -> Observable<Data> in
                do {
                    let imageData = try Self.imageData(
                        from: image,
                        maxDimension: maxDimension,
                        mimeType: mimeType
                    )
                    return .just(imageData)
                } catch {
                    return .error(error)
                }
            }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }

    private static func imageData(from image: UIImage,
                                  maxDimension: CGFloat?,
                                  mimeType: ImageMimeType) throws -> Data {
        var adjustedImage = image
        if let maxDimension = maxDimension,
           let resizedImage = image.resized(withMaxDimension: maxDimension) {
            adjustedImage = resizedImage
        }

        let imageData: Data?
        switch mimeType {
        case .png:
            imageData = adjustedImage.pngData()
        case .jpeg:
            imageData = adjustedImage.jpegData(compressionQuality: 0.8)
        }

        if let imageData = imageData {
            return imageData
        }
        throw Error.invalidImage
    }
}
