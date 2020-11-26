//
//  Created by Dmitry Frishbuter on 08/04/2020
//  Copyright © 2019 98 Training Pty Limited. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {

    func decode<T: Decodable>(_ key: KeyedDecodingContainer.Key) throws -> T {
        return try decode(T.self, forKey: key)
    }

    func decodeIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }

    func decodeDate(_ key: KeyedDecodingContainer.Key, format: DateFormat) throws -> Date {
        let dateString = try decode(String.self, forKey: key)
        let dateFormatter = DateFormatter(format: format)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            throw DecodingError.dateCorruptedError(forKey: key, in: self)
        }
    }

    func decodeDateIfPresent(_ key: KeyedDecodingContainer.Key, format: DateFormat) throws -> Date? {
        guard let dateString = try decodeIfPresent(String.self, forKey: key) else {
            return nil
        }
        let dateFormatter = DateFormatter(format: format)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            throw DecodingError.dateCorruptedError(forKey: key, in: self)
        }
    }
}
