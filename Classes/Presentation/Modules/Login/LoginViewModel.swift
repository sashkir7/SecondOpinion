//
//  Created by Alexander Kireev on 08/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

struct LoginViewModel: Equatable {
    let email: String
    let password: String
    let isValid: Bool
    let isLoading: Bool

    init(state: LoginState) {
        email = state.email
        password = state.password
        isValid = state.isValid
        isLoading = state.isLoading
    }
}
