//
//  Created by Dmitry Frishbuter on 05.11.2018
//  Copyright © 2018 Ronas IT. All rights reserved.
//

import Foundation

enum DateFormat {
    case iso8601
    case iso8601Full
    case simpleDate
    case custom(String)

    var raw: String {
        switch self {
        case .iso8601:
            return "yyyy-MM-dd HH:mm:ss"
        case .iso8601Full:
            return "yyyy-MM-dd HH:mm:ss.SSS"
        case .simpleDate:
            return "yyyy-MM-dd"
        case .custom(let format):
            return format
        }
    }

    var locale: Locale? {
        switch self {
        case .iso8601, .iso8601Full:
            return Locale(identifier: "en_US_POSIX")
        default:
            return nil
        }
    }
}

extension DateFormatter {

    static var iso8601: DateFormatter {
        return .init(format: .iso8601)
    }

    static var iso8601Full: DateFormatter {
        return .init(format: .iso8601Full)
    }

    static var simpleDate: DateFormatter {
        return .init(format: .simpleDate)
    }

    convenience init(locale: Locale) {
        self.init()
        self.locale = locale
    }

    convenience init(format: DateFormat) {
        self.init()
        dateFormat = format.raw
        locale = format.locale
    }
}
