//
//  Created by Alexander Kireev on 08/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol LoginViewInput: class {
    @discardableResult
    func update(with viewModel: LoginViewModel, animated: Bool) -> Bool
    func setNeedsUpdate()
}

protocol LoginViewOutput: class {
    func viewDidLoad()
    func emailInputChanged(_ input: String)
    func passwordInputChanged(_ input: String)
    func resetPasswordActionTriggered()
    func logInActionTriggered()
}

final class LoginViewController: BaseAuthViewController {

    private(set) var viewModel: LoginViewModel
    let output: LoginViewOutput

    var needsUpdate: Bool = true

    private var logInButtonHeightWithInsets: CGFloat {
        let logInButtonTopInset = 30.heightWithRatio
        let logInButtonBottomInset = 20.heightWithRatio
        let logInButtonHeight: CGFloat = 52
        return logInButtonTopInset + logInButtonHeight + logInButtonBottomInset
    }

    private lazy var logoAccountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = Asset.icAccount.image
        return imageView
    }()

    private lazy var loginTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .titleFont(ofSize: 34)
        label.textColor = .cyprus
        label.text = L10n.LoginModule.loginTitle
        return label
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .mediumAppFont(ofSize: 15)
        label.textColor = .cyprus
        label.text = L10n.EmailEditing.EmailInput.title
        return label
    }()

    private lazy var emailTextField: AppTextField = .make(withPlaceholder: L10n.EmailEditing.EmailInput.placeholder) {
        $0.keyboardType = .emailAddress
        $0.setTextInputTraits(with: .email)
        $0.delegate = self
        $0.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: .editingChanged)
    }

    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .mediumAppFont(ofSize: 15)
        label.textColor = .cyprus
        label.text = L10n.PasswordEditing.PasswordInput.title
        return label
    }()

    private lazy var passwordTextField: PasswordTextField = .make(withPlaceholder: L10n.PasswordEditing.PasswordEnter.placholder) {
        $0.addTarget(self, action: #selector(passwordTextFieldChanged(_:)), for: .editingChanged)
        $0.delegate = self
    }

    private lazy var forgotPasswordButton: AppButton = {
        let button = AppButton()
        button.titleLabel?.font = .appFont(ofSize: 15)
        button.setTitleColor(.manatee, for: .normal)
        button.addTarget(self, action: #selector(forgotButtonPressed), for: .touchUpInside)
        button.setTitle(L10n.PasswordEditing.PasswordForgot.title, for: .normal)
        return button
    }()

    private lazy var logInButton: AppButton = {
        let button = AppButton()
        button.isEnabled = false
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .mediumAppFont(ofSize: 17)
        button.setTitleColor(.manatee, for: .normal)
        button.backgroundColor = .solitude
        button.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        button.setTitle(L10n.logIn, for: .normal)
        return button
    }()

    // MARK: -  Lifecycle

    init(viewModel: LoginViewModel, output: LoginViewOutput) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()

        view.backgroundColor = .white

        scrollView.addSubviews(
            logoAccountImageView,
            loginTitleLabel,
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            forgotPasswordButton,
            logInButton
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        logoAccountImageView.configureFrame { maker in
            maker.top(inset: 116.heightWithRatio).centerX()
            maker.size(width: 64, height: 64)
        }
        loginTitleLabel.configureFrame { maker in
            maker.top(to: logoAccountImageView.nui_bottom, inset: 46.heightWithRatio).heightToFit()
            maker.left(inset: 68.widthWithRatio).right(inset: 68.widthWithRatio)
        }
        emailLabel.configureFrame { maker in
            maker.top(to: loginTitleLabel.nui_bottom, inset: 48.heightWithRatio).height(20)
            maker.left(inset: 20.widthWithRatio).widthToFit()
        }
        emailTextField.configureFrame { maker in
            maker.top(to: emailLabel.nui_bottom, inset: 8.heightWithRatio).height(56)
            maker.left(inset: 20.widthWithRatio).right(inset: 20.widthWithRatio)
        }
        passwordLabel.configureFrame { maker in
            maker.top(to: emailTextField.nui_bottom, inset: 24.heightWithRatio).height(20)
            maker.left(inset: 20.widthWithRatio).widthToFit()
        }
        passwordTextField.configureFrame { maker in
            maker.top(to: passwordLabel.nui_bottom, inset: 8.heightWithRatio).height(56)
            maker.left(inset: 20.widthWithRatio).right(inset: 20.widthWithRatio)
        }
        forgotPasswordButton.configureFrame { maker in
            maker.top(to: passwordTextField.nui_bottom, inset: 16.heightWithRatio).height(20)
            maker.left(inset: 20.widthWithRatio).widthToFit()
        }

        setupScrollViewContentSize()

        logInButton.configureFrame { maker in
            maker.left(inset: 20.widthWithRatio).right(inset: 20.widthWithRatio).height(52)

            guard !isKeyboardShown else {
                maker.top(to: forgotPasswordButton.nui_bottom, inset: 30.heightWithRatio)
                return
            }

            if scrollView.frame.height > forgotPasswordButton.frame.maxY + logInButtonHeightWithInsets {
                maker.bottom(inset: 38.heightWithRatio)
            } else {
                maker.top(to: forgotPasswordButton.nui_bottom, inset: 30.heightWithRatio)
            }
        }
    }

    // MARK: -  Actions

    @objc func emailTextFieldChanged(_ textField: UITextField) {
        output.emailInputChanged(textField.text ?? "")
    }

    @objc func passwordTextFieldChanged(_ textField: UITextField) {
        output.passwordInputChanged(textField.text ?? "")
    }

    @objc func forgotButtonPressed() {
        output.resetPasswordActionTriggered()
    }

    @objc func logInButtonPressed() {
        output.logInActionTriggered()
    }

    // MARK: -  Private

    private func setupScrollViewContentSize() {
        scrollView.contentSize.width = scrollView.bounds.width

        if isKeyboardShown {
            scrollView.contentSize.height = forgotPasswordButton.frame.maxY + logInButtonHeightWithInsets
            return
        }

        if forgotPasswordButton.frame.maxY + logInButtonHeightWithInsets < scrollView.bounds.height {
            scrollView.contentSize.height = scrollView.bounds.height
        } else {
            scrollView.contentSize.height = forgotPasswordButton.frame.maxY + logInButtonHeightWithInsets
        }
    }
}

// MARK: -  LoginViewInput

extension LoginViewController: LoginViewInput, ViewUpdatable {

    func setNeedsUpdate() {
        needsUpdate = true
    }

    @discardableResult
    func update(with viewModel: LoginViewModel, animated: Bool) -> Bool {
        let oldViewModel = self.viewModel
        guard needsUpdate || viewModel != oldViewModel else {
            return false
        }
        self.viewModel = viewModel

        update(new: viewModel, old: oldViewModel, keyPath: \.email) { email in
            emailTextField.text = email
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.password) { password in
            passwordTextField.text = password
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.isValid) { isValid in
            if isValid {
                logInButton.isEnabled = true
                logInButton.backgroundColor = .eveningSea
                logInButton.setTitleColor(.white, for: .normal)
            } else {
                logInButton.isEnabled = false
                logInButton.backgroundColor = .solitude
                logInButton.setTitleColor(.manatee, for: .normal)
            }
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.isLoading) { isLoading in
            logInButton.isLoading = isLoading
        }

        needsUpdate = false

        return true
    }
}
