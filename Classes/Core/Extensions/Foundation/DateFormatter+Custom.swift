//
//  Created by Dmitry Frishbuter on 19.04.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import Foundation

extension DateFormatter {

    static func make(withDateFormat dateFormat: String = "dd/MM/yyyy", timezone: TimeZone = .utc) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = timezone
        return dateFormatter
    }
}
