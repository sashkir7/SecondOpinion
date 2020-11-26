//
//  Created by Alx Krw on 08.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit
import Framezilla

final class AppButton: UIButton {

    var enabledSettings = (backgroundColor: UIColor.eveningSea, tintColor: UIColor.white)
    var disabledSettings = (backgroundColor: UIColor.solitude, tintColor: UIColor.manatee)

    var isLoading: Bool = false {
        didSet {
            guard isLoading != oldValue else {
                return
            }
            if isLoading {
                titleLabel?.alpha = 0
                imageView?.transform = CGAffineTransform(scaleX: 0, y: 0)
                activityIndicatorView.startAnimating()
                isUserInteractionEnabled = false
            } else {
                titleLabel?.alpha = 1
                imageView?.transform = .identity
                activityIndicatorView.stopAnimating()
                isUserInteractionEnabled = true
            }
        }
    }

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = enabledSettings.backgroundColor
                tintColor = enabledSettings.tintColor
            } else {
                backgroundColor = disabledSettings.backgroundColor
                tintColor = disabledSettings.tintColor
            }
        }
    }

    // MARK: -  Subviews

    private lazy var activityIndicatorView = UIActivityIndicatorView()

    // MARK: -  Lifecycle

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addSubview(activityIndicatorView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.configureFrame { maker in
            maker.size(width: 24, height: 24).center()
        }
    }

    // MARK: -  Helpers

    func setActivityIndicatorColor(_ color: UIColor) {
        activityIndicatorView.color = color
    }
}
