//
//  Created by Nikita Zatsepilov on 31.10.2019
//  Copyright © 2019 Ronas IT. All rights reserved.
//

import Foundation
import RxSwift
import Networking

extension NetworkService: ReactiveCompatible {}

extension Reactive where Base: NetworkService {

    func request(endpoint: Endpoint) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            let request = self.request(for: endpoint, observer: observer)
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func nonCancellableRequest(endpoint: Endpoint) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            self.request(for: endpoint, observer: observer)
            return Disposables.create()
        }
    }

    func request<Response: Decodable>(endpoint: Endpoint, decoder: JSONDecoder = .init()) -> Observable<Response> {
        return Observable.create { observer -> Disposable in
            let request = self.request(endpoint: endpoint, decoder: decoder, observer: observer)
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func nonCancellableRequest<Response: Decodable>(endpoint: Endpoint, decoder: JSONDecoder = .init()) -> Observable<Response> {
        return Observable.create { observer -> Disposable in
            self.request(endpoint: endpoint, decoder: decoder, observer: observer)
            return Disposables.create()
        }
    }

    func uploadRequest<Response: Decodable>(endpoint: UploadEndpoint, decoder: JSONDecoder = .init()) -> Observable<Response> {
        Observable.create { observer in
            self.base.uploadRequest(for: endpoint, decoder: decoder, success: { (response: Response) in
                observer.onNext(response)
                observer.onCompleted()
            }, failure: { error in
                observer.onError(error)
            })
            return Disposables.create()
        }
    }

    @discardableResult
    private func request(for endpoint: Endpoint, observer: AnyObserver<Void>) -> CancellableRequest {
        return base.request(for: endpoint, success: {
            observer.onNext(())
            observer.onCompleted()
        }, failure: { error in
            observer.onError(error)
        })
    }

    @discardableResult
    private func request<Response: Decodable>(endpoint: Endpoint,
                                              decoder: JSONDecoder = .init(),
                                              observer: AnyObserver<Response>) -> CancellableRequest {
        return base.request(for: endpoint, decoder: decoder, success: { (response: Response) in
            observer.onNext(response)
            observer.onCompleted()
        }, failure: { error in
            observer.onError(error)
        })
    }
}
