//
//  Created by Alexander Kireev on 25/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol ConsultationUploadFilesViewInput: class {
    @discardableResult
    func update(with viewModel: ConsultationUploadFilesViewModel, animated: Bool) -> Bool
    func setNeedsUpdate()
}

protocol ConsultationUploadFilesViewOutput: class {
    func viewDidLoad()
    func skipOrAddFileActionTriggered()
    func addOrConfirmActionTriggered()
    func closeActionTriggered()
}

final class ConsultationUploadFilesViewController: UIViewController {

    private(set) var viewModel: ConsultationUploadFilesViewModel
    let output: ConsultationUploadFilesViewOutput

    var needsUpdate: Bool = true

    private lazy var uploadFilesTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.attributedText = NSAttributedString(
            string: L10n.NewConsultation.UploadFiles.title,
            attributes: StringAttributes.largeTitle()
        )

        return label
    }()

    private lazy var uploadFilesSubtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(
            string: L10n.NewConsultation.UploadFiles.subtitle,
            attributes: StringAttributes.textFieldPlaceholder()
        )
        label.textAlignment = .left
        return label
    }()

    private lazy var skipOrAddFileButton: AppButton = .make(withTitle: L10n.skip) { button in
        button.backgroundColor = .white
        button.setTitleColor(.eveningSea, for: .normal)
        button.addTarget(self, action: #selector(skipOrAddFileButtonPressed), for: .touchUpInside)
    }

    private lazy var addOrConfirmButton: AppButton = .make(withTitle: L10n.addFile) { button in
        button.isEnabled = true
        button.addTarget(self, action: #selector(addOrConfirmButtonPressed), for: .touchUpInside)
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

    init(viewModel: ConsultationUploadFilesViewModel, output: ConsultationUploadFilesViewOutput) {
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

        view.addSubviews(
            uploadFilesTitleLabel,
            uploadFilesSubtitleLabel,
            skipOrAddFileButton,
            addOrConfirmButton
        )

        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = navBarCloseButton
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        uploadFilesTitleLabel.configureFrame { maker in
            maker.top(inset: 53.heightWithRatio).left(inset: 20.widthWithRatio)
            maker.sizeThatFits(size: CGSize(width: view.bounds.width, height: view.bounds.height))
        }
        uploadFilesSubtitleLabel.configureFrame { maker in
            maker.top(to: uploadFilesTitleLabel.nui_bottom, inset: 8.heightWithRatio).heightToFit()
            maker.left(inset: 20.widthWithRatio).widthToFit()
        }
        addOrConfirmButton.configureFrame { maker in
            maker.bottom(inset: 38.heightWithRatio).height(52)
            maker.left(inset: 20.widthWithRatio).right(inset: 20.widthWithRatio)
        }
        skipOrAddFileButton.configureFrame { maker in
            maker.bottom(to: addOrConfirmButton.nui_top, inset: 9.heightWithRatio).height(52)
            maker.left(inset: 20.widthWithRatio).right(inset: 20.widthWithRatio)
        }
    }

    // MARK: -  Actions

    @objc private func closeButtonPressed() {
        output.closeActionTriggered()
    }

    @objc private func skipOrAddFileButtonPressed() {
        output.skipOrAddFileActionTriggered()
    }

    @objc private func addOrConfirmButtonPressed() {
        output.addOrConfirmActionTriggered()
    }
}

// MARK: -  ConsultationUploadFilesViewInput

extension ConsultationUploadFilesViewController: ConsultationUploadFilesViewInput, ViewUpdatable {

    func setNeedsUpdate() {
        needsUpdate = true
    }

    @discardableResult
    func update(with viewModel: ConsultationUploadFilesViewModel, animated: Bool) -> Bool {
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
