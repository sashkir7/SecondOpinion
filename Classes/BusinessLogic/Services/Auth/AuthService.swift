//
//  Created by Continuous Integration on 16.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit.UIApplication
import Networking
import RxSwift

final class AuthService: NetworkService, AuthServiceProtocol {

    private let sessionService: SessionServiceProtocol

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.make(withDateFormat: DateFormat.iso8601.raw))
        return decoder
    }()

    init(sessionService: SessionServiceProtocol,
         requestAdaptingService: RequestAdaptingServiceProtocol,
         errorHandlingService: ErrorHandlingServiceProtocol) {
        self.sessionService = sessionService
        super.init(requestAdaptingService: requestAdaptingService, errorHandlingService: errorHandlingService)
    }

    func signUpObservable(with parameters: SignUpParameters) -> Observable<User> {
        return rx.request(endpoint: AuthEndpoint.signUp(parameters))
            .map { [weak self] (response: AuthResponse) in
                self?.sessionService.startSession(with: response.user, token: response.token)
                return response.user
            }
    }

    func signInObservable(withEmail email: String, password: String) -> Observable<User> {
        let endpoint = AuthEndpoint.signIn(email: email, password: password)
        return rx.request(endpoint: endpoint, decoder: decoder)
            .map { [weak self] (response: AuthResponse) in
                self?.sessionService.startSession(with: response.user, token: response.token)
                return response.user
            }
    }

    func resetPasswordObservable(withEmail email: String) -> Observable<Void> {
        return rx.request(endpoint: AuthEndpoint.forgotPassword(email: email))
    }

    func restorePasswordObservable(with parameters: RestoreParameters) -> Observable<Void> {
        return rx.request(endpoint: AuthEndpoint.restorePassword(parameters))
    }
}

private final class AuthResponse: Decodable {
    let token: String
    let user: User

    private enum CodingKeys: String, CodingKey {
        case token
        case user
    }
}
