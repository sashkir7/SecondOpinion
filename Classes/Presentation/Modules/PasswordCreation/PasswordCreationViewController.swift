//
//  Created by Dmitry Surkov on 19/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol PasswordCreationViewInput: class {
    @discardableResult
    func update(with viewModel: PasswordCreationViewModel, animated: Bool) -> Bool
    func setNeedsUpdate()
}

protocol PasswordCreationViewOutput: class {
    func viewDidLoad()
    func newPasswordInputChanged(_ input: String)
    func passwordConfirmationInputChanged(_ input: String)
    func createNewPasswordActionTriggered()
}

final class PasswordCreationViewController: BaseAuthViewController {

    private(set) var viewModel: PasswordCreationViewModel
    let output: PasswordCreationViewOutput

    var needsUpdate: Bool = true

    private enum Layout {
        static let textFieldHeight: CGFloat = 56
        static let textFieldLineSpacing: CGFloat = 24.heightWithRatio
        static let lineSpacing: CGFloat = 8.heightWithRatio
        static let horizontalInset: CGFloat = 20.widthWithRatio

        static let createNewPasswordButtonTopInset: CGFloat = 47.heightWithRatio
        static let createNewPasswordButtonHeight: CGFloat = 52
        static let createNewPasswordButtonBottomInset: CGFloat = 38.heightWithRatio

        static let createNewPasswordButtonHeightWithInsets: CGFloat =
            createNewPasswordButtonTopInset +
            createNewPasswordButtonHeight +
            createNewPasswordButtonBottomInset
    }

    private lazy var logoRestorePasswordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = Asset.icRestorePassword.image
        return imageView
    }()

    private let createNewPasswordTitleLabel = UILabel()
    private let newPasswordTitleLabel = UILabel()
    private let confirmNewPasswordTitleLabel = UILabel()

    private lazy var newPasswordTextField: PasswordTextField =
        .make(withPlaceholder: L10n.PasswordCreation.CreateNewPasswordEnter.placeholder) {
            $0.addTarget(self, action: #selector(enterNewPasswordEditingChanged), for: .editingChanged)
            $0.textContentType = .newPassword
            $0.delegate = self
        }

    private lazy var confirmNewPasswordTextField: PasswordTextField =
        .make(withPlaceholder: L10n.PasswordCreation.ConfirmNewPasswordEnter.placeholder) {
            $0.addTarget(self, action: #selector(enterConfirmNewPasswordEditingChanged), for: .editingChanged)
            $0.textContentType = .newPassword
            $0.delegate = self
        }

    private lazy var createNewPasswordButton: AppButton = {
        let button = AppButton()
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .mediumAppFont(ofSize: 17)
        button.setTitleColor(.manatee, for: .normal)
        button.setActivityIndicatorColor(.white)
        button.backgroundColor = .solitude
        button.addTarget(self, action: #selector(createNewPasswordButtonPressed), for: .touchUpInside)
        button.setTitle(L10n.PasswordCreation.Action.createNewPassword, for: .normal)
        return button
    }()

    private var textFieldLabels: [UILabel] {
        return [newPasswordTitleLabel, confirmNewPasswordTitleLabel]
    }

    override var textFields: [UITextField] {
        return [newPasswordTextField, confirmNewPasswordTextField]
    }

    // MARK: -  Lifecycle

    init(viewModel: PasswordCreationViewModel, output: PasswordCreationViewOutput) {
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

        scrollView.addSubviews(textFieldLabels)
        scrollView.addSubviews(textFields)
        scrollView.addSubviews(
            logoRestorePasswordImageView,
            createNewPasswordTitleLabel,
            createNewPasswordButton
        )

        updateTitleLabels()

        output.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        logoRestorePasswordImageView.configureFrame { maker in
            maker.top(inset: 116.heightWithRatio).centerX()
            maker.size(width: 64, height: 64)
        }

        createNewPasswordTitleLabel.configureFrame { maker in
            maker.top(to: logoRestorePasswordImageView.nui_bottom, inset: 24.heightWithRatio)
            maker.centerX()
            maker.sizeToFit()
        }

        var textFieldIndex = 0
        zip(textFieldLabels, textFields).forEach { label, textField in
            label.configureFrame { maker in
                if label == newPasswordTitleLabel {
                    maker.top(to: createNewPasswordTitleLabel.nui_bottom, inset: 48.heightWithRatio)
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

        setupScrollViewContentSize()

        createNewPasswordButton.configureFrame { maker in
            maker.left(inset: Layout.horizontalInset).right(inset: Layout.horizontalInset)
            maker.height(Layout.createNewPasswordButtonHeight)

            if confirmNewPasswordTextField.frame.maxY + Layout.createNewPasswordButtonHeightWithInsets < scrollView.bounds.height {
                maker.bottom(inset: Layout.createNewPasswordButtonBottomInset)
            } else {
                maker.top(to: confirmNewPasswordTextField.nui_bottom, inset: Layout.createNewPasswordButtonTopInset)
            }
        }
    }

    // MARK: -  Actions

    @objc private func enterNewPasswordEditingChanged(_ textField: UITextField) {
        output.newPasswordInputChanged(textField.text ?? "")
    }

    @objc private func enterConfirmNewPasswordEditingChanged(_ textField: UITextField) {
        output.passwordConfirmationInputChanged(textField.text ?? "")
    }

    @objc private func createNewPasswordButtonPressed() {
        output.createNewPasswordActionTriggered()
    }

    // MARK: -  Private

    private func updateTitleLabels() {
        createNewPasswordTitleLabel.attributedText = NSAttributedString(
            string: L10n.PasswordCreation.mainTitle,
            attributes: StringAttributes.largeTitle()
        )

        newPasswordTitleLabel.attributedText = NSAttributedString(
            string: L10n.PasswordCreation.CreateNewPasswordInput.title,
            attributes: StringAttributes.textFieldTitle()
        )

        confirmNewPasswordTitleLabel.attributedText = NSAttributedString(
            string: L10n.PasswordCreation.ConfirmNewPasswordInput.title,
            attributes: StringAttributes.textFieldTitle()
        )
    }

    private func setupScrollViewContentSize() {
        scrollView.contentSize.width = scrollView.bounds.width

        if isKeyboardShown {
            scrollView.contentSize.height = confirmNewPasswordTextField.frame.maxY + Layout.createNewPasswordButtonHeightWithInsets
            return
        }

        if confirmNewPasswordTextField.frame.maxY + Layout.createNewPasswordButtonHeightWithInsets < scrollView.bounds.height {
            scrollView.contentSize.height = scrollView.bounds.height
        } else {
            scrollView.contentSize.height = confirmNewPasswordTextField.frame.maxY + Layout.createNewPasswordButtonHeightWithInsets
        }
    }
}

// MARK: -  PasswordCreationViewInput

extension PasswordCreationViewController: PasswordCreationViewInput, ViewUpdatable {

    func setNeedsUpdate() {
        needsUpdate = true
    }

    @discardableResult
    func update(with viewModel: PasswordCreationViewModel, animated: Bool) -> Bool {
        let oldViewModel = self.viewModel
        guard needsUpdate || viewModel != oldViewModel else {
            return false
        }
        self.viewModel = viewModel

        update(new: viewModel, old: oldViewModel, keyPath: \.newPassword) { password in
            newPasswordTextField.text = password
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.passwordConfirmation) { password in
            confirmNewPasswordTextField.text = password
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.isValid) { isValid in
            createNewPasswordButton.isEnabled = isValid
            if isValid {
                createNewPasswordButton.backgroundColor = .eveningSea
                createNewPasswordButton.setTitleColor(.white, for: .normal)
            } else {
                createNewPasswordButton.backgroundColor = .solitude
                createNewPasswordButton.setTitleColor(.manatee, for: .normal)
            }
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.isLoading) { isLoading in
            createNewPasswordButton.isLoading = isLoading
        }

        needsUpdate = false

        return true
    }
}
