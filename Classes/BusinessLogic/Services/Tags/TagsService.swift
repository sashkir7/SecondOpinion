//
//  Created by Alexander Kireev on 25/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Foundation
import Networking
import RxSwift

final class TagsService: NetworkService, TagsServiceProtocol {

    private let sessionService: SessionServiceProtocol

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.make(withDateFormat: DateFormat.iso8601.raw))
        return decoder
    }()

    init(sessionService: SessionServiceProtocol,
         requestAdaptingService: RequestAdaptingServiceProtocol,
         errorHandlingService: ErrorHandlingServiceProtocol) {
        self.sessionService = sessionService
        super.init(requestAdaptingService: requestAdaptingService, errorHandlingService: errorHandlingService)
    }

    func fetchTagsObservable() -> Observable<[Tag]> {
        return rx.request(endpoint: TagsEndpoint.fetchTags, decoder: decoder)
            .map { (response: TagResponse) in
                response.tags
            }
    }
}

private final class TagResponse: Codable {
    let tags: [Tag]

    private enum CodingKeys: String, CodingKey {
        case tags = "data"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tags = try container.decode(.tags)
    }
}
