//
//  Created by Dmitry Surkov on 08/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

final class SignUpState {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var isValid: Bool
    var isLoading: Bool = false

    init(firstName: String = "",
         lastName: String = "",
         email: String = "",
         password: String = "",
         isValid: Bool = false) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.isValid = isValid
    }
}
