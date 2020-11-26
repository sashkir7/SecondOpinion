//
//  Created by Dmitry Surkov on 19/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

struct PasswordCreationViewModel: Equatable {
    let newPassword: String
    let passwordConfirmation: String
    let isValid: Bool
    let isLoading: Bool

    init(state: PasswordCreationState) {
        newPassword = state.newPassword
        passwordConfirmation = state.passwordConfirmation
        isValid = state.isValid
        isLoading = state.isLoading
    }

    static func == (lhs: PasswordCreationViewModel, rhs: PasswordCreationViewModel) -> Bool {
        return lhs.newPassword == rhs.newPassword &&
               lhs.passwordConfirmation == rhs.passwordConfirmation &&
               lhs.isValid == rhs.isValid &&
               lhs.isLoading == rhs.isLoading
    }
}
