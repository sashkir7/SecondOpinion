//
//  Created by Alx Krw on 22.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

extension UIImage {

    func with(color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            self.draw(at: .zero)
            context.fill(
                CGRect(x: 0, y: 0, width: size.width, height: size.height),
                blendMode: .sourceAtop
            )
        }
    }
}
