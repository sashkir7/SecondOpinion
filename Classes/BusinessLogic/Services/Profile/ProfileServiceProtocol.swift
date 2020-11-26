//
//  Created by Dmitry Frishbuter on 07/04/2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import RxSwift

protocol HasProfileService {
    var profileService: ProfileServiceProtocol { get }
}

protocol ProfileServiceProtocol: class {
    func fetchProfileObservable() -> Observable<User>
    func updateProfileObservable(for user: User) -> Observable<User>
}
