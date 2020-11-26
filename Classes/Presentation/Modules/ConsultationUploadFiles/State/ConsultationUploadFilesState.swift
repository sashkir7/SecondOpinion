//
//  Created by Alexander Kireev on 25/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

final class ConsultationUploadFilesState {
    var createdConsultationParameters: CreatedConsultationParameters
    var uploadFiles: [UIImage]
    var isValid: Bool
    var isLoading: Bool

    init(createdConsultationParameters: CreatedConsultationParameters = CreatedConsultationParameters(),
         uploadFiles: [UIImage] = [],
         isValid: Bool = false,
         isLoading: Bool = false) {
        self.createdConsultationParameters = createdConsultationParameters
        self.uploadFiles = uploadFiles
        self.isValid = isValid
        self.isLoading = isLoading
    }
}
