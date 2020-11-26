//
//  Created by Dmitry Surkov on 08/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit
import ActiveLabel

protocol SignUpViewInput: class {
    @discardableResult
    func update(with viewModel: SignUpViewModel, animated: Bool) -> Bool
    func setNeedsUpdate()
}

protocol SignUpViewOutput: class {
    func viewDidLoad()
    func firstNameInputChanged(_ input: String)
    func lastNameInputChanged(_ input: String)
    func emailInputChanged(_ input: String)
    func passwordInputChanged(_ input: String)
    func createAccountActionTriggered()
    func termsAndConditionsActionTriggered()
}

final class SignUpViewController: BaseAuthViewController {

    private enum Layout {
        static let textFieldHeight: CGFloat = 56
        static let textFieldLineSpacing: CGFloat = 24.heightWithRatio
        static let lineSpacing: CGFloat = 8.heightWithRatio
        static let horizontalInset: CGFloat = 20.widthWithRatio

        static let createAccountButtonHeight: CGFloat = 52
        static let createAccountButtonTopInset: CGFloat = 47.heightWithRatio
        static let createAccountButtonBottomInset: CGFloat = 38.heightWithRatio
    }

    private(set) var viewModel: SignUpViewModel
    let output: SignUpViewOutput

    var needsUpdate: Bool = true

    private var createAccountButtonHeightWithInsets: CGFloat {
        return Layout.createAccountButtonTopInset + Layout.createAccountButtonHeight + Layout.createAccountButtonBottomInset
    }

    private let signUpTitleLabel = UILabel()
    private let firstNameTitleLabel = UILabel()
    private let lastNameTitleLabel = UILabel()
    private let emailTitleLabel = UILabel()
    private let passwordTitleLabel = UILabel()

    private lazy var agreementLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.enabledTypes = [.custom(pattern: L10n.SignUp.Action.termsAndCondition)]

        label.configureLinkAttribute = { _, attributes, isSelected in
            var mAttributes = attributes
            mAttributes[.foregroundColor] = isSelected ? UIColor.eveningSea.withAlphaComponent(0.5) : UIColor.eveningSea
            mAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
            return mAttributes
        }

        let agreementAttributedString = NSMutableAttributedString(string: "\(L10n.SignUp.agreementTitle)\n")
        let termsAndConditionAttributedString = NSMutableAttributedString(string: L10n.SignUp.Action.termsAndCondition)

        let fullAttributedString = NSMutableAttributedString()
        fullAttributedString.append(agreementAttributedString)
        fullAttributedString.append(termsAndConditionAttributedString)

        fullAttributedString.addAttributes(StringAttributes.agreementTitle(), range: NSRange(location: 0, length: fullAttributedString.length))

        label.attributedText = fullAttributedString
        label.numberOfLines = 0

        label.handleCustomTap(for: .custom(pattern: L10n.SignUp.Action.termsAndCondition)) { [weak output] _ in
            output?.termsAndConditionsActionTriggered()
        }
        return label
    }()

    private lazy var firstNameTextField: AppTextField = .make(withPlaceholder: L10n.PersonalInformationEditing.FirstNameInput.placeholder) {
        $0.addTarget(self, action: #selector(firstNameTextFieldChanged), for: .editingChanged)
        $0.setTextInputTraits(with: .name)
        $0.delegate = self
    }

    private lazy var lastNameTextField: AppTextField = .make(withPlaceholder: L10n.PersonalInformationEditing.LastNameInput.placeholder) {
        $0.addTarget(self, action: #selector(lastNameTextFieldChanged), for: .editingChanged)
        $0.setTextInputTraits(with: .name)
        $0.delegate = self
    }

    private lazy var emailTextField: AppTextField = .make(withPlaceholder: L10n.EmailEditing.EmailInput.placeholder) {
        $0.addTarget(self, action: #selector(enterEmailEditingChanged(_:)), for: .editingChanged)
        $0.setTextInputTraits(with: .email)
        $0.delegate = self
    }

    private lazy var passwordTextField: PasswordTextField = .make(withPlaceholder: L10n.PasswordEditing.PasswordCreate.placholder) {
        $0.addTarget(self, action: #selector(enterPasswordEditingChanged(_:)), for: .editingChanged)
        $0.textContentType = .newPassword
        $0.delegate = self
    }

    private lazy var createAccountButton: AppButton = {
        let button = AppButton()
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .mediumAppFont(ofSize: 17)
        button.setTitleColor(.manatee, for: .normal)
        button.setActivityIndicatorColor(.white)
        button.backgroundColor = .solitude
        button.addTarget(self, action: #selector(createAccountButtonPressed), for: .touchUpInside)
        button.setTitle(L10n.SignUp.Action.createAccount, for: .normal)
        return button
    }()

    private var textFieldLabels: [UILabel] {
        return [firstNameTitleLabel, lastNameTitleLabel, emailTitleLabel, passwordTitleLabel]
    }

    override var textFields: [UITextField] {
        return [firstNameTextField, lastNameTextField, emailTextField, passwordTextField]
    }

    // MARK: -  Lifecycle

    init(viewModel: SignUpViewModel, output: SignUpViewOutput) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        scrollView.addSubviews(textFields)
        scrollView.addSubviews(textFieldLabels)
        scrollView.addSubviews(
            signUpTitleLabel,
            agreementLabel,
            createAccountButton
        )

        updateSignUpTitleLabel()
        updateTitleLabels()

        output.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        signUpTitleLabel.configureFrame { maker in
            maker.top(inset: 89.heightWithRatio)
            maker.left(inset: Layout.horizontalInset)
            maker.width(156).heightToFit()
        }

        var textFieldIndex = 0
        zip(textFieldLabels, textFields).forEach { label, textField in
            label.configureFrame { maker in
                if label == firstNameTitleLabel {
                    maker.top(to: signUpTitleLabel.nui_bottom, inset: 40.heightWithRatio)
                } else {
                    maker.top(to: textFields[textFieldIndex].nui_bottom, inset: Layout.textFieldLineSpacing)
                    textFieldIndex += 1
                }
                maker.left(inset: Layout.horizontalInset)
                maker.sizeToFit()
            }

            textField.configureFrame { maker in
                maker.top(to: label.nui_bottom, inset: Layout.lineSpacing)
                maker.left(inset: Layout.horizontalInset).right(inset: Layout.horizontalInset)
                maker.height(Layout.textFieldHeight)
            }
        }

        agreementLabel.configureFrame { maker in
            maker.top(to: passwordTextField.nui_bottom, inset: Layout.textFieldLineSpacing)
            maker.left(inset: Layout.horizontalInset).right(inset: Layout.horizontalInset)
            maker.width(261).heightToFit()
        }

        setupScrollViewContentSize()

        createAccountButton.configureFrame { maker in
            maker.left(inset: Layout.horizontalInset).right(inset: Layout.horizontalInset)
            maker.height(Layout.createAccountButtonHeight)

            guard !isKeyboardShown else {
                maker.top(to: agreementLabel.nui_bottom, inset: Layout.createAccountButtonTopInset)
                return
            }

            if agreementLabel.frame.maxY + createAccountButtonHeightWithInsets < scrollView.bounds.height {
                maker.bottom(inset: Layout.createAccountButtonBottomInset)
            } else {
                maker.top(to: agreementLabel.nui_bottom, inset: Layout.createAccountButtonTopInset)
            }
        }
    }

    // MARK: -  Actions

    @objc private func firstNameTextFieldChanged(_ textField: UITextField) {
        output.firstNameInputChanged(textField.text ?? "")
    }

    @objc private func lastNameTextFieldChanged(_ textField: UITextField) {
        output.lastNameInputChanged(textField.text ?? "")
    }

    @objc private func enterEmailEditingChanged(_ textField: UITextField) {
        output.emailInputChanged(textField.text ?? "")
    }

    @objc private func enterPasswordEditingChanged(_ textField: UITextField) {
        output.passwordInputChanged(textField.text ?? "")
    }

    @objc private func createAccountButtonPressed() {
        output.createAccountActionTriggered()
    }

    // MARK: -  Private

    private func updateSignUpTitleLabel() {
        signUpTitleLabel.attributedText = NSAttributedString(
            string: L10n.SignUp.mainTitle,
            attributes: StringAttributes.largeTitle()
        )
        signUpTitleLabel.numberOfLines = 0
    }

    private func updateTitleLabels() {
        firstNameTitleLabel.attributedText = NSAttributedString(
            string: L10n.PersonalInformationEditing.FirstNameInput.title,
            attributes: StringAttributes.textFieldTitle()
        )

        lastNameTitleLabel.attributedText = NSAttributedString(
            string: L10n.PersonalInformationEditing.LastNameInput.title,
            attributes: StringAttributes.textFieldTitle()
        )

        emailTitleLabel.attributedText = NSAttributedString(
            string: L10n.EmailEditing.EmailInput.title,
            attributes: StringAttributes.textFieldTitle()
        )

        passwordTitleLabel.attributedText = NSAttributedString(
            string: L10n.PasswordEditing.PasswordInput.title,
            attributes: StringAttributes.textFieldTitle()
        )
    }

    private func setupScrollViewContentSize() {
        scrollView.contentSize.width = scrollView.bounds.width

        if isKeyboardShown {
            scrollView.contentSize.height = agreementLabel.frame.maxY + createAccountButtonHeightWithInsets
            return
        }

        if agreementLabel.frame.maxY + createAccountButtonHeightWithInsets < scrollView.bounds.height {
            scrollView.contentSize.height = scrollView.bounds.height
        } else {
            scrollView.contentSize.height = agreementLabel.frame.maxY + createAccountButtonHeightWithInsets
        }
    }
}

// MARK: -  SignUpViewInput

extension SignUpViewController: SignUpViewInput, ViewUpdatable {

    func setNeedsUpdate() {
        needsUpdate = true
    }

    @discardableResult
    func update(with viewModel: SignUpViewModel, animated: Bool) -> Bool {
        let oldViewModel = self.viewModel
        guard needsUpdate || viewModel != oldViewModel else {
            return false
        }
        self.viewModel = viewModel

        update(new: viewModel, old: oldViewModel, keyPath: \.firstName) { firstName in
            firstNameTextField.text = firstName
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.lastName) { lastName in
            lastNameTextField.text = lastName
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.email) { email in
            emailTextField.text = email
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.password) { password in
            passwordTextField.text = password
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.isValid) { isValid in
            createAccountButton.isEnabled = isValid
            if isValid {
                createAccountButton.backgroundColor = .eveningSea
                createAccountButton.setTitleColor(.white, for: .normal)
            } else {
                createAccountButton.backgroundColor = .solitude
                createAccountButton.setTitleColor(.manatee, for: .normal)
            }
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.isLoading) { isLoading in
            createAccountButton.isLoading = isLoading
        }

        needsUpdate = false

        return true
    }
}
