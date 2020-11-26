//
//  Created by Alexander Kireev on 25/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

struct ConsultationUploadFilesViewModel: Equatable {
//    let uploadFiles: [UII]
    let isValid: Bool
    let isLoading: Bool

    init(state: ConsultationUploadFilesState) {
//        uploadFiles = state.uploadFiles
        isValid = state.isValid
        isLoading = state.isLoading
    }
}
