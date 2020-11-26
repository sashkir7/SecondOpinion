//
//  Created by Alexander Kireev on 19/10/2020
//  Copyright © 2020 RonasIT. All rights reserved.
//

final class ResetPasswordState {
    var email: String
    var isValid: Bool
    var isLoading: Bool = false

    init(email: String = "", isValid: Bool = false) {
        self.email = email
        self.isValid = isValid
    }
}
