//
//  Created by Continuous Integration on 13.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

final class PasswordTextField: AppTextField {

    private lazy var securityButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.icEyeNormal.image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(securityButtonPressed), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        rightViewMode = .always
        isSecureTextEntry = true
        rightView = securityButton
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext(),
              let rightView = self.rightView else {
            return
        }

        context.setStrokeColor(UIColor.manatee.withAlphaComponent(0.1).cgColor)
        context.setLineWidth(1.0)
        context.move(to: rightView.frame.origin)
        context.addLine(to: CGPoint(x: rightView.frame.minX, y: rightView.frame.maxY))
        context.strokePath()
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        guard let view = rightView, !view.isHidden else {
            return super.rightViewRect(forBounds: bounds)
        }

        let additionalWidthForRightView: CGFloat = 4.0

        return CGRect(
            x: bounds.width - bounds.height - additionalWidthForRightView,
            y: 0,
            width: bounds.height + additionalWidthForRightView,
            height: bounds.height
        )
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        guard let view = rightView, !view.isHidden else {
            return rect
        }
        rect.size.width -= rightViewRect(forBounds: bounds).width - insetX
        return rect
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        guard let view = rightView, !view.isHidden else {
            return rect
        }
        rect.size.width -= rightViewRect(forBounds: bounds).width - insetX
        return rect
    }

    // MARK: -  Actions

    @objc private func securityButtonPressed() {
        isSecureTextEntry.toggle()
        let image = isSecureTextEntry ? Asset.icEyeNormal.image : Asset.icEyeDisabled.image
        securityButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
    }
}
