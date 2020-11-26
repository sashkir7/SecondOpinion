//
//  Created by Dmitry Frishbuter on 09/04/2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import Networking
import RxSwift

protocol HasSessionService {
    var sessionService: SessionServiceProtocol { get }
}

protocol SessionServiceProtocol: class, AccessTokenSupervisor {
    var isAuthorized: Bool { get }
    var user: User? { get }

    func userObservable() -> Observable<User?>
    func sessionExpiredObservable() -> Observable<Void>

    func startSession(with user: User, token: String)
    func updateSession(with user: User)
    func logout()
}
