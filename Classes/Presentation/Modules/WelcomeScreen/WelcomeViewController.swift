//
//  Created by Alexander Kireev on 06/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit
import Framezilla

protocol WelcomeViewInput: class {
    @discardableResult
    func update(with viewModel: WelcomeViewModel, animated: Bool) -> Bool
    func setNeedsUpdate()
}

protocol WelcomeViewOutput: class {
    func viewDidLoad()
    func signUpActionTriggered()
    func logInActionTriggered()
}

final class WelcomeViewController: UIViewController {

    private(set) var viewModel: WelcomeViewModel
    let output: WelcomeViewOutput

    var needsUpdate: Bool = true

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = Asset.imgWelcomeBackground.image
        return imageView
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Asset.icLogo.image
        return imageView
    }()

    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .titleFont(ofSize: 34)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = L10n.WelcomeModule.mainTitle
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .appFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = L10n.WelcomeModule.subtitle
        return label
    }()

    private lazy var signUpButton: AppButton = {
        let button = AppButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.setTitleColor(.eveningSea, for: .normal)
        button.titleLabel?.font = .mediumAppFont(ofSize: 17)
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        button.setTitle(L10n.signUp, for: .normal)
        return button
    }()

    private lazy var logInButton: AppButton = {
        let button = AppButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .mediumAppFont(ofSize: 17)
        button.setTitle(L10n.logIn, for: .normal)
        button.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var imageViewGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = imageView.frame
        gradientLayer.colors = [UIColor.deepFir.withAlphaComponent(0.05).cgColor,
                                UIColor.deepFir.withAlphaComponent(0.25).cgColor,
                                UIColor.deepFir.withAlphaComponent(0.9).cgColor,
                                UIColor.deepFir.withAlphaComponent(1).cgColor]
        gradientLayer.locations = [0, 0.41, 0.75, 0.92]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return gradientLayer
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: -  Lifecycle

    init(viewModel: WelcomeViewModel, output: WelcomeViewOutput) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        view.addSubviews(
            imageView,
            logoImageView,
            mainTitleLabel,
            subtitleLabel,
            signUpButton,
            logInButton
        )
        output.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        imageView.configureFrame { maker in
            maker.edges(insets: .zero)
        }
        imageView.layer.addSublayer(imageViewGradientLayer)

        logInButton.configureFrame { maker in
            maker.bottom(inset: 42).height(52)
            maker.left(inset: 20).right(inset: 20)
        }
        signUpButton.configureFrame { maker in
            maker.bottom(to: logInButton.nui_top, inset: 8).height(52)
            maker.left(inset: 20).right(inset: 20)
        }
        subtitleLabel.configureFrame { maker in
            maker.bottom(to: signUpButton.nui_top, inset: 48).height(22)
            maker.left(inset: 37).right(inset: 37)
        }
        mainTitleLabel.configureFrame { maker in
            maker.bottom(to: subtitleLabel.nui_top, inset: 20).heightToFit()
            maker.left(inset: 48).right(inset: 49)
        }
        logoImageView.configureFrame { maker in
            maker.bottom(to: mainTitleLabel.nui_top, inset: 16)
            maker.size(width: 68, height: 68).centerX()
        }
    }

    // MARK: -  Actions

    @objc func signUpButtonPressed() {
        output.signUpActionTriggered()
    }

    @objc func logInButtonPressed() {
        output.logInActionTriggered()
    }
}

// MARK: -  SignInViewInput

extension WelcomeViewController: WelcomeViewInput, ViewUpdatable {

    func setNeedsUpdate() {
        needsUpdate = true
    }

    @discardableResult
    func update(with viewModel: WelcomeViewModel, animated: Bool) -> Bool {
        let oldViewModel = self.viewModel
        guard needsUpdate || viewModel != oldViewModel else {
            return false
        }
        self.viewModel = viewModel

        // update view

        needsUpdate = false

        return true
    }
}
