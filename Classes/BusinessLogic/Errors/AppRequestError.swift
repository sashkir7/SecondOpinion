//
//  Created by Nikita Zatsepilov on 09.11.2019
//  Copyright © 2019 98 Training Pty Limited. All rights reserved.
//

import Foundation

final class AppRequestError: Decodable {

    enum CodingKeys: String, CodingKey {
        case error
        case message
        case errors
    }

    struct BundledError: LocalizedError {
        let fieldName: String
        let message: String
        let description: String?

        var failureReason: String? {
            return message
        }

        var errorDescription: String? {
            return description
        }
    }

    let message: String
    let bundledErrors: [BundledError]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let message: String = try? container.decode(.error) {
            self.message = message
        } else if let message: String = try? container.decode(.message) {
            self.message = message
        } else {
            throw DecodingError.dataCorrupted
        }

        // TODO: -  Change error message description later
        typealias ErrorJSON = [String: String] // swiftlint:disable:this nesting
        if let rawBundledErrors: [String: [ErrorJSON]] = try? container.decode(.errors) {
            bundledErrors = rawBundledErrors.keys.reduce(into: [BundledError]()) { errors, fieldName in
                if let errorJSONs: [ErrorJSON] = rawBundledErrors[fieldName] {
                    errors += errorJSONs.map { (json: ErrorJSON) in
                        return BundledError(
                            fieldName: fieldName,
                            message: json["message"] ?? L10n.Error.unknown,
                            description: json["description"] ?? L10n.Error.serverError
                        )
                    }
                }
            }
        } else if let rawBundledErrors: [String: [String]] = try? container.decode(.errors) {
            bundledErrors = rawBundledErrors.keys.reduce(into: [BundledError]()) { errors, fieldName in
                if let errorMessages: [String] = rawBundledErrors[fieldName] {
                    errors += errorMessages.map { (message: String) in
                        return BundledError(
                            fieldName: fieldName,
                            message: message,
                            description: nil
                        )
                    }
                }
            }
        } else {
            bundledErrors = []
        }
    }
}

// MARK: -  LocalizedError

extension AppRequestError: LocalizedError {

    var failureReason: String? {
        return bundledErrors.first?.message ?? L10n.Error.unknown
    }

    var errorDescription: String? {
        return bundledErrors.first?.description
    }
}
