//
//  Created by Dmitry Frishbuter on 08.05.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import UIKit

extension UITextInput {

    var selectedRangeStart: Int? {
        guard let selectedRange = selectedTextRange else {
            return nil
        }
        return offset(from: beginningOfDocument, to: selectedRange.start)
    }
}
