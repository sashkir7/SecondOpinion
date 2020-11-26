//
//  Created by Continuous Integration on 16.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import RxSwift

protocol HasAuthService {
    var authService: AuthServiceProtocol { get }
}

protocol AuthServiceProtocol: class {
    func signUpObservable(with parameters: SignUpParameters) -> Observable<User>
    func signInObservable(withEmail email: String, password: String) -> Observable<User>
    func resetPasswordObservable(withEmail email: String) -> Observable<Void>
    func restorePasswordObservable(with parameters: RestoreParameters) -> Observable<Void>
}
