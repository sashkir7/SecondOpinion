//
//  Created by Alexander Kireev on 21/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

struct NewConsultationViewModel: Equatable {
    let consultationName: String
    let description: String
    let isLoading: Bool
    let isValid: Bool

    init(state: NewConsultationState) {
        consultationName = state.consultationName
        description = state.description
        isLoading = state.isLoading
        isValid = state.isValid
    }
}
