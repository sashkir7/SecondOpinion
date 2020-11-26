//
//  Created by Alx Krw on 16.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

extension Comparable {

    func clamped(min: Self, max: Self) -> Self {
        Swift.min(Swift.max(self, min), max)
    }

    func clamped(to range: ClosedRange<Self>) -> Self {
        clamped(min: range.lowerBound, max: range.upperBound)
    }

    func clamped(to range: Range<Self>) -> Self {
        clamped(min: range.lowerBound, max: range.upperBound)
    }
}
