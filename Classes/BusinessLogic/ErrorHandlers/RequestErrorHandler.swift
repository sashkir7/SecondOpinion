//
//  Created by Nikita Zatsepilov on 09.11.2019
//  Copyright © 2019 Ronas IT. All rights reserved.
//

import Foundation
import Networking

final class RequestErrorHandler: ErrorHandler {

    private lazy var decoder: JSONDecoder = .init()

    func handleError(with requestError: ErrorPayload, completion: @escaping Completion) {
        print((try? JSONSerialization.jsonObject(with: (requestError.response.data)!, options: [])) ?? "nil")
        if let data = requestError.response.data,
           let error: AppRequestError = try? decoder.decode(from: data) {
            let resultError: Error = error.bundledErrors.first ?? error
            completion(.continueErrorHandling(with: resultError))
        } else {
            completion(.continueErrorHandling(with: requestError.error))
        }
    }
}
