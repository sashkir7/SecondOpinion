//
//  Created by Alx Krw on 29.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

struct TagCellModel: Equatable {
    let title: String

    init(state: TagCellState) {
        title = state.title
    }

    static func == (lhs: TagCellModel, rhs: TagCellModel) -> Bool {
        return lhs.title == rhs.title
    }
}
