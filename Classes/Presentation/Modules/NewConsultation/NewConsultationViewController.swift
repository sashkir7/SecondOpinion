//
//  Created by Alexander Kireev on 21/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol NewConsultationViewInput: class {
    @discardableResult
    func update(with viewModel: NewConsultationViewModel, animated: Bool) -> Bool
    func setNeedsUpdate()
}

protocol NewConsultationViewOutput: class {
    func viewDidLoad()
    func consultationNameChanged(_ input: String)
    func consultationDescriptionChanged(_ input: String)
    func closeActionTriggered()
    func nextActionTriggered()
}

final class NewConsultationViewController: BaseAuthViewController {

    private(set) var viewModel: NewConsultationViewModel
    let output: NewConsultationViewOutput

    var needsUpdate: Bool = true

    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.attributedText = NSAttributedString(
            string: L10n.NewConsultation.addConsultation,
            attributes: StringAttributes.largeTitle()
        )
        return label
    }()

    private lazy var consultationNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .cyprus
        label.font = .appFont(ofSize: 15)
        label.text = L10n.NewConsultation.ConsultationName.title
        return label
    }()

    private lazy var consultationNameTextField: AppTextField = .make(
        withPlaceholder: L10n.NewConsultation.ConsultationName.placeholder,
        configHandler: {
            $0.delegate = self
            $0.addTarget(self, action: #selector(consultationNameTextFieldChanged), for: .editingChanged)
        }
    )

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .cyprus
        label.font = .appFont(ofSize: 15)
        label.text = L10n.NewConsultation.Description.title
        return label
    }()

    private lazy var descriptionTextView: AppTextView = .make(withPlaceholder: L10n.NewConsultation.Description.placeholder) {
        $0.delegate = self
    }

    private lazy var nextButton: AppButton = .make(withTitle: L10n.next) { button in
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }

    private lazy var navBarCloseButton: UIBarButtonItem = {
        return UIBarButtonItem(
            image: Asset.icClose.image.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(closeButtonPressed)
        )
    }()

    // MARK: -  Lifecycle

    init(viewModel: NewConsultationViewModel, output: NewConsultationViewOutput) {
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

        scrollView.addSubviews(
            mainTitleLabel,
            consultationNameLabel,
            consultationNameTextField,
            descriptionLabel,
            descriptionTextView,
            nextButton
        )

        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = navBarCloseButton
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let topActionButtonInset = 30.heightWithRatio
        let actionButtonHeight: CGFloat = 52
        let bottomActionButtonInset = 30.heightWithRatio

        let heightWithInsets = topActionButtonInset + actionButtonHeight + bottomActionButtonInset

        mainTitleLabel.configureFrame { maker in
            maker.top(inset: 53.heightWithRatio).left(inset: 20.widthWithRatio)
            maker.sizeThatFits(size: CGSize(width: scrollView.bounds.width, height: .greatestFiniteMagnitude))
        }
        consultationNameLabel.configureFrame { maker in
            maker.top(to: mainTitleLabel.nui_bottom, inset: 32.heightWithRatio).height(20)
            maker.left(inset: 20.widthWithRatio).widthToFit()
        }
        consultationNameTextField.configureFrame { maker in
            maker.top(to: consultationNameLabel.nui_bottom, inset: 8.heightWithRatio).height(56)
            maker.left(inset: 20.widthWithRatio).right(inset: 20.widthWithRatio)
        }
        descriptionLabel.configureFrame { maker in
            maker.top(to: consultationNameTextField.nui_bottom, inset: 24.heightWithRatio).height(20)
            maker.left(inset: 20.widthWithRatio).widthToFit()
        }
        descriptionTextView.configureFrame { maker in
            maker.top(to: descriptionLabel.nui_bottom, inset: 8.heightWithRatio).height(140)
            maker.left(inset: 20.widthWithRatio).right(inset: 20.widthWithRatio)
        }

        setupScrollViewContentSize(withHeightWithInsets: heightWithInsets)

        nextButton.configureFrame { maker in
            maker.left(inset: 20.widthWithRatio).right(inset: 20.widthWithRatio).height(actionButtonHeight)

            guard !isKeyboardShown else {
                maker.top(inset: descriptionTextView.frame.maxY + topActionButtonInset)
                return
            }

            if scrollView.frame.height > descriptionTextView.frame.maxY + heightWithInsets {
                maker.bottom(inset: bottomActionButtonInset)
            } else {
                maker.top(inset: descriptionTextView.frame.maxY + topActionButtonInset)
            }
        }
    }

    // MARK: -  TextViewDelegate

    func textViewDidChange(_ textView: UITextView) {
        output.consultationDescriptionChanged(textView.text ?? "")
    }

    // MARK: -  Actions

    @objc func closeButtonPressed() {
        output.closeActionTriggered()
    }

    @objc func consultationNameTextFieldChanged(_ textField: UITextField) {
        output.consultationNameChanged(textField.text ?? "")
    }

    @objc func nextButtonPressed() {
        output.nextActionTriggered()
    }

//    MARK: -  Private

    private func setupScrollViewContentSize(withHeightWithInsets heightWithInsets: CGFloat) {
        scrollView.contentSize.width = scrollView.bounds.width

        if isKeyboardShown {
            scrollView.contentSize.height = descriptionTextView.frame.maxY + heightWithInsets
            return
        }

        if descriptionTextView.frame.maxY + heightWithInsets < scrollView.bounds.height {
            scrollView.contentSize.height = scrollView.bounds.height
        } else {
            scrollView.contentSize.height = descriptionTextView.frame.maxY + heightWithInsets
        }
    }
}

// MARK: -  NewConsultationViewInput

extension NewConsultationViewController: NewConsultationViewInput, ViewUpdatable {

    func setNeedsUpdate() {
        needsUpdate = true
    }

    @discardableResult
    func update(with viewModel: NewConsultationViewModel, animated: Bool) -> Bool {
        let oldViewModel = self.viewModel
        guard needsUpdate || viewModel != oldViewModel else {
            return false
        }
        self.viewModel = viewModel

        update(new: viewModel, old: oldViewModel, keyPath: \.consultationName) { name in
            consultationNameTextField.text = name
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.isValid) { isValid in
            nextButton.isEnabled = isValid
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.isLoading) { isLoading in
            nextButton.isLoading = isLoading
        }

        needsUpdate = false

        return true
    }
}
