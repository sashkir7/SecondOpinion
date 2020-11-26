//
//  Created by Alexander Kireev on 26/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Foundation
import Networking
import RxSwift

final class ConsultationService: NetworkService, ConsultationServiceProtocol {

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

    func createConsultation(with parametres: CreatedConsultationParameters) -> Observable<Void> {
        return rx.request(endpoint: ConsultationEndpoint.createConsultation(parametres))
    }
}
