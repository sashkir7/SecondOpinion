//
//  Created by Dmitry Frishbuter on 07/04/2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import Foundation
import Networking
import RxSwift

final class ProfileService: NetworkService, ProfileServiceProtocol {

    private let sessionService: SessionServiceProtocol
    private let authService: AuthServiceProtocol

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.make(withDateFormat: DateFormat.iso8601.raw))
        return decoder
    }()

    init(sessionService: SessionServiceProtocol,
         authService: AuthServiceProtocol,
         requestAdaptingService: RequestAdaptingServiceProtocol,
         errorHandlingService: ErrorHandlingServiceProtocol) {
        self.sessionService = sessionService
        self.authService = authService
        super.init(requestAdaptingService: requestAdaptingService, errorHandlingService: errorHandlingService)
    }

    func fetchProfileObservable() -> Observable<User> {
        return rx.request(endpoint: ProfileEndpoint.fetchProfile, decoder: decoder)
            .onNext { [weak self] user in
                self?.sessionService.updateSession(with: user)
            }
    }

    func updateProfileObservable(for user: User) -> Observable<User> {
        return rx.nonCancellableRequest(endpoint: ProfileEndpoint.updateProfile(user), decoder: decoder)
            .flatMap(weak: self) { (strongSelf: ProfileService, _: User) -> Observable<User> in
                return strongSelf.fetchProfileObservable()
            }
    }
}
