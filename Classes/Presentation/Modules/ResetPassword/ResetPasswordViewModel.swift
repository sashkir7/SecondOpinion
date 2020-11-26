//
//  Created by Alexander Kireev on 19/10/2020
//  Copyright © 2020 RonasIT. All rights reserved.
//

struct ResetPasswordViewModel: Equatable {
    var email: String
    var isValid: Bool
    var isLoading: Bool = false

    init(state: ResetPasswordState) {
        email = state.email
        isValid = state.isValid
        isLoading = state.isLoading
    }
}
