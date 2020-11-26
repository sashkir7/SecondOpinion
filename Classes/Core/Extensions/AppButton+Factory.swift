//
//  Created by Alx Krw on 29.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

extension AppButton {

    static func make<Button: AppButton>(withTitle title: String, configHandler: (Button) -> Void) -> Button {
        let button = Button(type: .system)
        button.layer.cornerRadius = 16
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .mediumAppFont(ofSize: 17)
        configHandler(button)
        return button
    }
}
