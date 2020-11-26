//
//  Created by Alexander Kireev on 26/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import RxSwift

protocol HasConsultationService {
    var consultationService: ConsultationServiceProtocol { get }
}

protocol ConsultationServiceProtocol: class {
    func createConsultation(with parametres: CreatedConsultationParameters) -> Observable<Void>
}
