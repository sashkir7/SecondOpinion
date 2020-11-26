//
//  Created by Dmitry Frishbuter on 27.04.2020
//  Copyright © 2020 98 Training Pty Limited. All rights reserved.
//

import UIKit

final class AlertAction {

    let title: String?
    let style: UIAlertAction.Style
    var handler: (() -> Void)?

    init(title: String? = nil, style: UIAlertAction.Style, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

extension AlertAction {

    static func cancel(handler: (() -> Void)? = nil) -> AlertAction {
        return .init(title: L10n.cancel, style: .cancel, handler: handler)
    }

    static func ok(handler: (() -> Void)? = nil) -> AlertAction {
        return .init(title: L10n.ok, style: .default, handler: handler)
    }
}
