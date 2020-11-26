//
//  Created by Alx Krw on 27.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import Foundation

struct CreatedConsultationParameters {
    var consultationName: String
    var consultationDescription: String
    var selectedTagsID: [UInt]

    // TODO: Variable for added files

    init(consultationName: String = "", consultationDescription: String = "", selectedTagsID: [UInt] = []) {
        self.consultationName = consultationName
        self.consultationDescription = consultationDescription
        self.selectedTagsID = selectedTagsID
    }
}

extension CreatedConsultationParameters: JSONConvertible {

    func asJSONObject() -> [String: Any] {
        return [
            "name": consultationName,
            "description": consultationDescription,
            "tags": selectedTagsID
        ]
    }
}
