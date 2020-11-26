//
//  Created by Dmitry Frishbuter on 30.06.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import Foundation

extension TimeZone {

    static var utc: TimeZone = TimeZone(secondsFromGMT: 0)!

    init?(hoursFromGMT: Int) {
        self.init(secondsFromGMT: hoursFromGMT * 3600)
    }
}
