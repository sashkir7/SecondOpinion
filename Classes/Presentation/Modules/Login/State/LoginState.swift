//
//  Created by Alexander Kireev on 08/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

final class LoginState {
    var email: String
    var password: String
    var isValid: Bool
    var isLoading: Bool

    init(email: String = "", password: String = "", isValid: Bool = false, isLoading: Bool = false) {
        self.email = email
        self.password = password
        self.isValid = isValid
        self.isLoading = isLoading
    }

}
