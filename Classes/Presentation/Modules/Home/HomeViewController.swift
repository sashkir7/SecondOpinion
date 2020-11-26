//
//  Created by Alexander Kireev on 21/10/2020
//  Copyright © 2020 Ronas IT. All rights reserved.
//

import UIKit

protocol HomeViewInput: class {
    @discardableResult
    func update(with viewModel: HomeViewModel, animated: Bool) -> Bool
    func setNeedsUpdate()
}

protocol HomeViewOutput: class {
    func viewDidLoad()
}

final class HomeViewController: UIViewController {

    private(set) var viewModel: HomeViewModel
    let output: HomeViewOutput

    var needsUpdate: Bool = true

    private lazy var aboutTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "This is user home screen"
        label.font = .titleFont(ofSize: 30)
        label.numberOfLines = 0
        label.backgroundColor = .gray
        label.textAlignment = .center
        return label
    }()

    // MARK: -  Lifecycle

    init(viewModel: HomeViewModel, output: HomeViewOutput) {
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

        view.addSubview(aboutTitleLabel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        aboutTitleLabel.configureFrame { maker in
            maker.sizeToFit().centerX().centerY()
        }
    }

    // MARK: -  Actions
}

// MARK: -  HomeViewInput

extension HomeViewController: HomeViewInput, ViewUpdatable {

    func setNeedsUpdate() {
        needsUpdate = true
    }

    @discardableResult
    func update(with viewModel: HomeViewModel, animated: Bool) -> Bool {
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
