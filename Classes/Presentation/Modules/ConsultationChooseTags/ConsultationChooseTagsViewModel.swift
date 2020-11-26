//
//  Created by Alexander Kireev on 23/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

struct ConsultationChooseTagsViewModel: Equatable {
    let tags: [Tag]
    let selectedTags: [Tag]
    let isValid: Bool
    let isLoading: Bool
    let cellModels: [TagCellModel]

    init(state: ConsultationChooseTagsState) {
        tags = state.tags
        selectedTags = state.selectedTags
        isValid = state.isValid
        isLoading = state.isLoading
        cellModels = state.tags.map { (tag: Tag) in
            TagCellModel(state: TagCellState(title: tag.name))
        }
    }

    static func == (lhs: ConsultationChooseTagsViewModel, rhs: ConsultationChooseTagsViewModel) -> Bool {
        return lhs.tags == rhs.tags &&
            lhs.selectedTags == rhs.selectedTags &&
            lhs.isValid == rhs.isValid &&
            lhs.isLoading == rhs.isLoading
    }
}
