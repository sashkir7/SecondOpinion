//
//  Created by Alexander Kireev on 23/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol ConsultationChooseTagsViewInput: class {
    @discardableResult
    func update(with viewModel: ConsultationChooseTagsViewModel, animated: Bool) -> Bool
    func setNeedsUpdate()
}

protocol ConsultationChooseTagsViewOutput: class {
    func viewDidLoad()
    func itemSelected(atIndex: Int)
    func itemDeselected(atIndex: Int)
    func closeActionTriggered()
    func nextActionTriggered()
}

final class ConsultationChooseTagsViewController: BaseAuthViewController {

    private(set) var viewModel: ConsultationChooseTagsViewModel
    let output: ConsultationChooseTagsViewOutput

    var needsUpdate: Bool = true

    private lazy var chooseTagsTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.attributedText = NSAttributedString(
            string: L10n.NewConsultation.ChooseTags.title,
            attributes: StringAttributes.largeTitle()
        )
        return label
    }()

    private lazy var tagsCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.registerCellClass(TagCollectionViewCell.self)
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var nextButton: AppButton = .make(withTitle: L10n.next) { button in
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }

    private lazy var tagsActivityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .cyprus
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }()

    private lazy var navBarCloseButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(
            image: Asset.icClose.image.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(closeButtonPressed)
        )
    }()

    // MARK: -  Lifecycle

    init(viewModel: ConsultationChooseTagsViewModel, output: ConsultationChooseTagsViewOutput) {
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

        scrollView.addSubviews(
            chooseTagsTitleLabel,
            tagsCollectionView,
            nextButton,
            tagsActivityIndicatorView
        )

        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = navBarCloseButtonItem

        output.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        chooseTagsTitleLabel.configureFrame { maker in
            maker.top(inset: 53.heightWithRatio).left(inset: 20.widthWithRatio)
            maker.sizeThatFits(size: CGSize(width: scrollView.bounds.width, height: .greatestFiniteMagnitude))
        }
        nextButton.configureFrame { maker in
            maker.bottom(inset: 38.heightWithRatio).height(52)
            maker.left(inset: 20.widthWithRatio).right(inset: 20.widthWithRatio)
        }
        tagsCollectionView.configureFrame { maker in
            maker.top(to: chooseTagsTitleLabel.nui_bottom, inset: 32.heightWithRatio)
            maker.bottom(to: nextButton.nui_top, inset: 32.heightWithRatio)
            maker.left(inset: 20.widthWithRatio).right(inset: 20.widthWithRatio)
        }
        tagsActivityIndicatorView.configureFrame { maker in
            maker.center().sizeToFit()
        }
    }

    // MARK: -  Actions

    @objc private func closeButtonPressed() {
        output.closeActionTriggered()
    }

    @objc private func nextButtonPressed() {
        output.nextActionTriggered()
    }
}

// MARK: -  ConsultationChooseTagsViewInput

extension ConsultationChooseTagsViewController: ConsultationChooseTagsViewInput, ViewUpdatable {

    func setNeedsUpdate() {
        needsUpdate = true
    }

    @discardableResult
    func update(with viewModel: ConsultationChooseTagsViewModel, animated: Bool) -> Bool {
        let oldViewModel = self.viewModel
        guard needsUpdate || viewModel != oldViewModel else {
            return false
        }
        self.viewModel = viewModel

        update(new: viewModel, old: oldViewModel, keyPath: \.tags) { _ in
            tagsCollectionView.reloadData()
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.isLoading) { isLoading in
            if isLoading {
                tagsActivityIndicatorView.isHidden = false
                tagsActivityIndicatorView.startAnimating()
            } else {
                tagsActivityIndicatorView.isHidden = true
                tagsActivityIndicatorView.stopAnimating()
            }
        }
        update(new: viewModel, old: oldViewModel, keyPath: \.isValid) { isValid in
            nextButton.isEnabled = isValid
        }

        needsUpdate = false

        return true
    }
}

// MARK: -  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension ConsultationChooseTagsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let cellModel = viewModel.cellModels[indexPath.item]
        cell.update(with: cellModel)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output.itemSelected(atIndex: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        output.itemDeselected(atIndex: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellModel = viewModel.cellModels[indexPath.item]
        let cell = TagCollectionViewCell.prototype
        cell.update(with: cellModel)

        let maxSize = CGSize(width: collectionView.bounds.width, height: 40)
        return cell.sizeThatFits(maxSize)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}
