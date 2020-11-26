//
//  Created by Alx Krw on 24.10.2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

final class TagCollectionViewCell: UICollectionViewCell {

    static var prototype: TagCollectionViewCell = .init()

    private let insets: UIEdgeInsets = .init(top: 9.5, left: 12, bottom: 9.5, right: 12)

    private enum Layout {
        static let topInset: CGFloat = 0
        static let bottomInset: CGFloat = 0

        static let leftInset: CGFloat = 12
        static let rightInset: CGFloat = 12
    }

    var title: String = "" {
        didSet {
            label.text = title
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.textColor = .white
                backgroundColor = .citrus
            } else {
                label.textColor = .cyprus
                backgroundColor = .solitude
            }
        }
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .appFont(ofSize: 17)
        label.textColor = .cyprus
        backgroundColor = .solitude
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 20
        addSubview(label)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.configureFrame { maker in
            maker.edges(insets: insets)
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return label.sizeThatFits(size - insets) + insets
    }

    func update(with cellModel: TagCellModel) {
        title = cellModel.title
        setNeedsLayout()
    }

}
