//
//  Created by Dmitry Frishbuter on 09/04/2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import Networking
import Alamofire
import RxSwift
import RxRelay

fileprivate extension String {
    static let token = "token"
}

final class SessionService: NetworkService, SessionServiceProtocol {

    private final class Session {
        var token: String
        var user: User?

        init(token: String, user: User? = nil) {
            self.token = token
            self.user = user
        }
    }

    private let keychainService: KeychainServiceProtocol
    private lazy var disposeBag: DisposeBag = .init()

    private var _session: Session?
    private var session: Session? {
        get {
            return _session
        }
        set {
            _session = newValue
            keychainService[.token] = newValue?.token
        }
    }

    private lazy var userRelay: BehaviorRelay<User?> = .init(value: user)
    private lazy var sessionExpiredRelay: PublishRelay<Void> = .init()

    var accessToken: String? {
        return session?.token
    }

    var isAuthorized: Bool {
        return session?.token != nil
    }

    var user: User? {
        return session?.user
    }

    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
        if let token = keychainService[.token] {
            _session = Session(token: token)
        }
        super.init()
    }

    func userObservable() -> Observable<User?> {
        return userRelay.asObservable()
    }

    func sessionExpiredObservable() -> Observable<Void> {
        return sessionExpiredRelay.asObservable()
    }

    func startSession(with user: User, token: String) {
        session = Session(token: token, user: user)
        userRelay.accept(user)
    }

    func updateSession(with user: User) {
        #if DEBUG
        print("✅ STARTED SESSION WITH USER ID: \(user.id)")
        #endif
        session?.user = user
        userRelay.accept(user)
    }

    func logout() {
        session = nil
        userRelay.accept(nil)
    }

    // MARK: -  AccessTokenSupervisor

    func refreshAccessToken(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        guard let token = accessToken else {
            handleSessionExpiration()
            return
        }
        let endpoint = RefreshTokenEndpoint(token: token)
        request(for: endpoint, success: { [weak self] (response: RefreshTokenResponse) in
            self?.updateToken(with: response.token)
            success()
        }, failure: { [weak self] _ in
            self?.handleSessionExpiration()
        })
    }

    // MARK: -  Private

    private func handleSessionExpiration() {
        logout()
        sessionExpiredRelay.accept(())
    }

    private func updateToken(with refreshedToken: String) {
        keychainService[.token] = refreshedToken
        session?.token = refreshedToken
    }
}

// MARK: -  RefreshTokenEndpoint

private struct RefreshTokenEndpoint: Endpoint {
    let path: String = "auth/refresh"
    let method: HTTPMethod = .get
    let parameters: Parameters? = nil
    let requiresAuthorization: Bool = false
    let authorizationType: AuthorizationType = .bearer

    let headers: [RequestHeader]

    init(token: String) {
        headers = [
            RequestHeaders.accept("application/json"),
            RequestHeaders.contentType("application/json"),
            RequestHeaders.authorization(authorizationType, token)
        ]
    }
}

// MARK: -  RefreshTokenResponse

private struct RefreshTokenResponse: Decodable {
    let token: String
}
