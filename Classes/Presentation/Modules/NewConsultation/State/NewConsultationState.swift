//
//  Created by Alexander Kireev on 21/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

final class NewConsultationState {
    var consultationName: String
    var description: String
    var isLoading: Bool
    var isValid: Bool

    init(consultationName: String = "", description: String = "", isLoading: Bool = false, isValid: Bool = false) {
        self.consultationName = consultationName
        self.description = description
        self.isLoading = isLoading
        self.isValid = isValid
    }
}
