//
//  Created by Dmitry Surkov on 19/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

final class PasswordCreationState {
    var token: String
    var newPassword: String
    var passwordConfirmation: String
    var isValid: Bool
    var isLoading: Bool = false

    init(token: String,
         newPassword: String = "",
         passwordConfirmation: String = "",
         isValid: Bool = false) {
        self.token = token
        self.newPassword = newPassword
        self.passwordConfirmation = passwordConfirmation
        self.isValid = isValid
    }
}
