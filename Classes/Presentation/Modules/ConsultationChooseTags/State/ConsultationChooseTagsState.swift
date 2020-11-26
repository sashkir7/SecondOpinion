//
//  Created by Alexander Kireev on 23/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

final class ConsultationChooseTagsState {
    var tags: [Tag]
    var selectedTags: [Tag]
    var isValid: Bool
    var isLoading: Bool

    init(tags: [Tag] = [], selectedTags: [Tag] = [], isValid: Bool = false, isLoading: Bool = false) {
        self.tags = tags
        self.selectedTags = selectedTags
        self.isValid = isValid
        self.isLoading = isLoading
    }
}
