//
//  Created by Continuous Integration on 26.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

extension Dictionary where Key == NSMutableAttributedString.Key, Value == Any {

     func colored(with color: UIColor) -> [NSAttributedString.Key: Any] {
        var newDictionary = self
        newDictionary[.foregroundColor] = color
        return newDictionary
    }
}
