//
//  Created by Alexander Kireev on 19/10/2020
//  Copyright © 2020 RonasIT. All rights reserved.
//

import UIKit

protocol ResetPasswordViewInput: class {
    @discardableResult
    func update(with viewModel: ResetPasswordViewModel, animated: Bool) -> Bool
    func setNeedsUpdate()
}

protocol ResetPasswordViewOutput: class {
    func viewDidLoad()
    func emailInputChanged(_ input: String)
    func resetPasswordActionTriggered()
}

final class ResetPasswordViewController: BaseAuthViewController {

    private(set) var viewModel: ResetPasswordViewModel
    let output: ResetPasswordViewOutput

    var needsUpdate: Bool = true

    private lazy var lockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Asset.icLock.image
        return imageView
    }()

    private lazy var resetPasswordTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .titleFont(ofSize: 34)
        label.textColor = .cyprus
        label.text = L10n.PasswordEditing.PasswordReset.title
        return label
    }()

    private lazy var emailTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .mediumAppFont(ofSize: 15)
        label.textColor = .cyprus
        label.text = L10n.EmailEditing.EmailInput.title
        return label
    }()

    private lazy var emailTextField: AppTextField = .make(withPlaceholder: L10n.EmailEditing.EmailInput.placeholder) {
        $0.keyboardType = .emailAddress
        $0.delegate = self
        $0.addTarget(self, action: #selector(emailTextFieldChanged(_:)), for: .editingChanged)
    }

    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .appFont(ofSize: 15)
        label.textColor = .manatee
        label.text = L10n.PasswordEditing.PasswordReset.detail
        return label
    }()

    private lazy var resetButton: AppButton = {
        let button = AppButton()
        button.isEnabled = false
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .appFont(ofSize: 17)
        button.setTitleColor(.manatee, for: .normal)
        button.backgroundColor = .solitude
        button.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
        button.setTitle(L10n.PasswordEditing.PasswordReset.title, for: .normal)
        return button
    }()

    // MARK: -  Lifecycle

    init(viewModel: ResetPasswordViewModel, output: ResetPasswordViewOutput) {
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
            lockImageView,
            resetPasswordTitleLabel,
            emailTitleLabel,
            emailTextField,
            detailLabel,
            resetButton
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let resetButtonBottomInset = 38.heightWithRatio
        let resetButtomHeight: CGFloat = 52
        let resetButtonTopInset = 24.heightWithRatio
        let resetButtonHeigthWithTopAndBottomInsets = resetButtonBottomInset + resetButtomHeight + resetButtonTopInset

        let detailLabelHeight: CGFloat = 40
        let detailLabelTopInset: CGFloat = 30.heightWithRatio
        let detailLabelHeightWithTopInset = detailLabelHeight + detailLabelTopInset

        let bottomItemsHeight = resetButtonHeigthWithTopAndBottomInsets + detailLabelHeightWithTopInset

        lockImageView.configureFrame { maker in
            maker.top(inset: 116.heightWithRatio)
            maker.centerX().size(width: 64, height: 64)
        }
        resetPasswordTitleLabel.configureFrame { maker in
            maker.top(to: lockImageView.nui_bottom, inset: 24.heightWithRatio).heightToFit()
            maker.left(inset: 49.widthWithRatio).right(inset: 49.widthWithRatio)
        }
        emailTitleLabel.configureFrame { maker in
            maker.top(to: resetPasswordTitleLabel.nui_bottom, inset: 48.heightWithRatio).heightToFit()
            maker.left(inset: 20.widthWithRatio).widthToFit()
        }
        emailTextField.configureFrame { maker in
            maker.top(to: emailTitleLabel.nui_bottom, inset: 8.heightWithRatio).height(56)
            maker.left(inset: 20.widthWithRatio).right(inset: 20.widthWithRatio)
        }

        setupScrollViewContentSize(withBottomItemsHeight: bottomItemsHeight)

        resetButton.configureFrame { maker in
            maker.left(inset: 20.widthWithRatio).right(inset: 20.widthWithRatio).height(resetButtomHeight)
            guard isKeyboardShown else {
                maker.bottom(inset: resetButtonBottomInset)
                return
            }

            if emailTextField.frame.maxY + bottomItemsHeight < scrollView.bounds.height {
                maker.bottom(inset: resetButtonBottomInset)
            } else {
                maker.top(to: detailLabel.nui_bottom, inset: resetButtonTopInset)
            }
        }

        detailLabel.configureFrame { maker in
            maker.left(inset: 20.widthWithRatio).right(inset: 20.widthWithRatio).heightToFit()
            guard isKeyboardShown else {
                maker.bottom(to: resetButton.nui_top, inset: resetButtonTopInset)
                return
            }

            if emailTextField.frame.maxY + bottomItemsHeight < scrollView.bounds.height {
                maker.bottom(to: resetButton.nui_top, inset: resetButtonTopInset)
            } else {
                maker.bottom(to: resetButton.nui_top, inset: resetButtonTopInset)
            }
        }
    }

    // MARK: -  Actions

    @objc func emailTextFieldChanged(_ textField: UITextField) {
        output.emailInputChanged(textField.text ?? "")
    }

    @objc func resetButtonPressed() {
        output.resetPasswordActionTriggered()
    }

    // MARK: -  Private

    private func setupScrollViewContentSize(withBottomItemsHeight bottomItemsHeight: CGFloat) {
        scrollView.contentSize.width = scrollView.bounds.width

        if isKeyboardShown {
            scrollView.contentSize.height = emailTextField.frame.maxY + bottomItemsHeight
            return
        }

        if emailTextField.frame.maxY + bottomItemsHeight < scrollView.bounds.height {
            scrollView.contentSize.height = scrollView.bounds.height
        } else {
            scrollView.contentSize.height = emailTextField.frame.maxY + bottomItemsHeight
        }
    }
}

// MARK: -  ResetPasswordViewInput

extension ResetPasswordViewController: ResetPasswordViewInput, ViewUpdatable {

    func setNeedsUpdate() {
        needsUpdate = true
    }

    @discardableResult
    func update(with viewModel: ResetPasswordViewModel, animated: Bool) -> Bool {
        let oldViewModel = self.viewModel
        guard needsUpdate || viewModel != oldViewModel else {
            return false
        }
        self.viewModel = viewModel

        update(new: viewModel, old: oldViewModel, keyPath: \.email) { email in
            emailTextField.text = email
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.isValid) { isValid in
            resetButton.isEnabled = isValid
            if isValid {
                resetButton.backgroundColor = .eveningSea
                resetButton.setTitleColor(.white, for: .normal)
            } else {
                resetButton.backgroundColor = .solitude
                resetButton.setTitleColor(.manatee, for: .normal)
            }
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.isLoading) { isLoading in
            resetButton.isLoading = isLoading
        }

        needsUpdate = false

        return true
    }
}
