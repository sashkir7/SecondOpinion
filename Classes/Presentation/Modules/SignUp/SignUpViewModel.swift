//
//  Created by Dmitry Surkov on 08/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

struct SignUpViewModel: Equatable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let isValid: Bool
    let isLoading: Bool

    init(state: SignUpState) {
        firstName = state.firstName
        lastName = state.lastName
        email = state.email
        password = state.password
        isValid = state.isValid
        isLoading = state.isLoading
    }

    static func == (lhs: SignUpViewModel, rhs: SignUpViewModel) -> Bool {
        return false
    }
}
